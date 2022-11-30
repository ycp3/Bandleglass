# frozen_string_literal: true

require "net/http"

module Riot
  class DDragonService
    def self.update!
      if outdated?
        download_raw
        extract_data
      end
    end

    def self.get_latest_version
      response = request(path: base_url + "api/versions.json")
      response[0]
    end

    private

    def self.extract_data
      
    end

    def self.download_raw
      FileUtils.rm_r Dir.glob("#{dir_raw}/*")

      version = get_latest_version
      uri = URI(base_url + "cdn/dragontail-#{version}.tgz")

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        File.open(dir_raw + version, "wb") do |file|
          http.request_get(uri.path) do |response|
            response.read_body do |chunk|
              puts "Downloaded #{chunk.length} bytes"
              file.write chunk
            end
          end
        end
      end
    end

    def self.outdated?
      Dir.children(dir_raw).empty? || Dir.children(dir_raw).first != get_latest_version
    end

    def self.dir_raw
      Rails.root.join("vendor", "assets", "raw")
    end

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
