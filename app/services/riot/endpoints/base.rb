# frozen_string_literal: true

module Riot
  class Endpoints::Base
    def self.call
      raise NotImplementedError
    end

    private

    def self.request(region:, path:)
      uri = URI(path)
      request_object = Net::HTTP::Get.new(uri)
      request_object["X-Riot-Token"] = ENV["RIOT_API_KEY"]
      limits_for_region(region: region).request
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request_object) }

      code = response.code
      if code == "200"
        limits_for_region(region: region).add_limits_from_response(response: response)
        JSON.parse(response.body)
      elsif code == "429"
        limits_for_region(region: region).pause_requests(duration: response["Retry-After"].to_i)
        request(region: region, path: path)
      else
        raise Net::HTTPResponse::CODE_TO_OBJ[code]
      end
    end

    def self.limits_for_region(region:)
      @mutex.synchronize do
        @limits[region] ||= Api::RateLimitGroup.new
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
