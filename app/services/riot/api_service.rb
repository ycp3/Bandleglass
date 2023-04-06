# frozen_string_literal: true

require "net/http"

module Riot
  class ApiService
    @limits = {}
    @mutex = Mutex.new

    def self.get_summoner_by_name(region:, name:)
      limit(region: region)
      request(
        region: region,
        endpoint: Endpoints::GetSummonerByName,
        options: {
          region: region,
          name: name
        }
      )
    end

    def self.get_summoner_by_puuid(region:, puuid:)
      limit(region: region)
      request(
        region: region,
        endpoint: Endpoints::GetSummonerByPuuid,
        options: {
          region: region,
          puuid: puuid
        }
      )
    end

    def self.get_match_ids_by_puuid(region:, puuid:, start: nil, count: nil, queue_type_id: nil)
      region = Regionable.region_to_platform(region: region)
      limit(region: region)
      request(
        region: region,
        endpoint: Endpoints::GetMatchIdsByPuuid,
        options: {
          region: region,
          puuid: puuid,
          start: start,
          count: count,
          queue_type_id: queue_type_id
        }
      )
    end

    def self.get_match_by_match_id(region:, match_id:)
      region = Regionable.region_to_platform(region: region)
      limit(region: region)
      request(
        region: region,
        endpoint: Endpoints::GetMatchByMatchId,
        options: {
          region: region,
          match_id: match_id
        }
      )
    end

    def self.get_league_entries_by_summoner_id(region:, summoner_id:)
      limit(region: region)
      request(
        region: region,
        endpoint: Endpoints::GetLeagueEntriesBySummonerId,
        options: {
          region: region,
          summoner_id: summoner_id
        }
      )
    end

    private

    def self.request(region:, endpoint:, options:)
      response = endpoint.call(**options)
      limits = limits_for_region(region: region)

      code = response.code
      if code == "200"
        limits.add_limits_from_response(response: response)
        JSON.parse(response.body)
      elsif code == "429"
        limits.pause_requests(duration: response["Retry-After"].to_i)
        request(region: region, endpoint: endpoint, options: options)
      end
    end

    def self.limit(region:)
      limits_for_region(region: region).request
    end

    def self.limits_for_region(region:)
      @mutex.synchronize do
        @limits[region] ||= Api::RateLimitGroup.new(use_app_headers: true)
      end
    end
  end
end
