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

    def self.get_match_ids_by_puuid(region:, puuid:, start: nil, count: nil, queue_type_id: nil)
      path = base_url(region: region, platform: true) + "lol/match/v5/matches/by-puuid/#{puuid}/ids"
      path = add_params(
        path: path,
        start: start,
        count: count,
        queue_type: queue_type_id
      )
      request(path: path)
    end

    def self.get_match_by_match_id(region:, match_id:)
      path = base_url(region: region, platform: true) + "lol/match/v5/matches/" + match_id
      request(path: path)
    end

    def self.get_league_entries_by_summoner_id(region:, summoner_id:)
      path = base_url(region: region) + "lol/league/v4/entries/by-summoner/" + summoner_id
      request(path: path)
    end

    private

    def self.request(region:, endpoint:, options:, platform: false)
      response = endpoint.call(**options)
      limited_region = platform ? Regionable.region_to_platform(region: region) : region
      limits = limits_for_region(region: limited_region)

      code = response.code
      if code == "200"
        limits.add_limits_from_response(response: response)
        JSON.parse(response.body)
      elsif code == "429"
        limits.pause_requests(duration: response["Retry-After"].to_i)
        request(region: region, endpoint: endpoint, options: options)
      end
    end

    def self.limit(region:, platform: false)
      region = Regionable.region_to_platform(region: region) if platform
      limits_for_region(region: region).request
    end

    def self.limits_for_region(region:)
      @mutex.synchronize do
        @limits[region] ||= Api::RateLimitGroup.new(use_app_headers: true)
      end
    end
  end
end
