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

    def self.download_raw(version:)
      FileUtils.rm Dir.glob(Rails.root.join("vendor", "assets", "raw", "*"))

      uri = URI(base_url + "cdn/dragontail-#{version}.tgz")

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        File.open(Rails.root.join("vendor", "assets", "raw", version), "wb") do |file|
          total_downloaded = 0
          puts "Downloading: #{uri.to_s}"
          print "Downloaded 0MB"
          http.request_get(uri.path) do |response|
            response.read_body do |chunk|
              print "\rDownloaded #{((total_downloaded += chunk.length) / 1048576.0).round(2)}MB"
              file.write chunk
            end
          end
          puts "\nDownload complete!"
        end
      end
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
