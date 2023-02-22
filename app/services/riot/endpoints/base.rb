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
      limits = limits_for_region(region: region)
      limits.request
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request_object) }

      code = response.code
      if code == "200"
        limits.add_limits_from_response(response: response)
      elsif code == "429"
        limits.pause_requests(duration: response["Retry-After"].to_i)
      else
        raise ArgumentError.new(code)
      end

      response
    end

    def self.limits_for_region(region:)
      @mutex.synchronize do
        @limits[region] ||= Api::RateLimitGroup.new
      end
    end

    def self.add_params(path:, **params)
      path += "?"
      params.each do |key, value|
        path += "&#{key}=#{value}" if value.present?
      end

      path
    end

    def self.base_url(region:)
      "https://" + region + ".api.riotgames.com/"
    end

    def self.base_url_closest
      "https://americas.api.riotgames.com/"
    end
  end
end
