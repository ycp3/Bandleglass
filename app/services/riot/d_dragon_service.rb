# frozen_string_literal: true

require "net/http"
require "rubygems/package"
require "zlib"

module Riot
  class DDragonService
    def self.latest_version
      response = request(path: base_url + "api/versions.json")
      response.first
    end

    private

    def self.request(path:)
      uri = URI(path)
      request_object = Net::HTTP::Get.new(uri)
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request_object) }

      JSON.parse(response.body)
    end

    def self.base_url
      "https://ddragon.leagueoflegends.com/"
    end
  end
end
