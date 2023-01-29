# frozen_string_literal: true

require "net/http"

module Riot
  class ApiService
    def self.get_summoner_by_name(region:, name:)
      Endpoints::GetSummonerByName.call(region: region, name: name)
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

    class BadRequestError < StandardError; end
    class UnauthorizedError < StandardError; end
    class ForbiddenError < StandardError; end
    class NotFoundError < StandardError; end
    class UnsupportedMediaTypeError < StandardError; end
    class InternalServerError < StandardError; end
    class ServiceUnavailable < StandardError; end

    RESPONSE_CODE_TO_ERROR = {
      400 => BadRequestError,
      401 => UnauthorizedError,
      403 => ForbiddenError,
      404 => NotFoundError,
      415 => UnsupportedMediaTypeError,
      500 => InternalServerError,
      503 => ServiceUnavailable
    }

    private

    def self.add_params(path:, **params)
      path += "?"
      params.each do |key, value|
        path += "&#{key}=#{value}" if value.present?
      end
      return path
    end

    def self.request(path:)
      uri = URI(path)
      request_object = Net::HTTP::Get.new(uri)
      request_object["X-Riot-Token"] = ENV["RIOT_API_KEY"]
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request_object) }

      code = response.code.to_i
      if code == 200
        JSON.parse(response.body)
      elsif code == 429
        sleep(response["Retry-After"].to_i)
        request(path: path)
      else
        raise RESPONSE_CODE_TO_ERROR[code]
      end
    end

    def self.base_url(region:, platform: false)
      host = if platform
        region_to_platform(region: region)
      else
        region
      end

      "https://" + host + ".api.riotgames.com/"
    end

    def self.base_url_closest
      "https://americas.api.riotgames.com/"
    end

    def self.region_to_platform(region:)
      if Regionable::AMERICAS_REGIONS.include? region
        "americas"
      elsif Regionable::EUROPE_REGIONS.include? region
        "europe"
      elsif Regionable::ASIA_REGIONS.include? region
        "asia"
      elsif Regionable::SEA_REGIONS.include? region
        "sea"
      end
    end
  end
end
