# frozen_string_literal: true

require "net/http"

module Riot
  class ApiService
    def self.get_summoner_by_name(region:, name:)
      path = base_url(region: region) + "lol/summoner/v4/summoners/by-name/" + name.gsub(" ", "%20")
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

    def self.request(path:)
      uri = URI(path)
      request_object = Net::HTTP::Get.new(uri)
      request_object["X-Riot-Token"] = ENV["RIOT_API_KEY"]
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request_object) }

      code = response.code.to_i
      if code == 200
        JSON.parse(response.body)
      elsif code == 429
        sleep(response["Retry-After"])
        request(uri: uri)
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
      if ["na1", "br1", "la1", "la2"].include? region
        "americas"
      elsif ["euw1", "eun1", "tr1", "ru"].include? region
        "europe"
      elsif ["kr", "jp1"].include? region
        "asia"
      else
        "sea"
      end
    end
  end
end
