# frozen_string_literal: true

require "net/http"
require "rubygems/package"
require "zlib"

module Riot
  class DDragonService
    def self.update!
      latest_version = get_latest_version
      if outdated?(latest_version: latest_version)
        download_raw(version: latest_version)
        extract_data(version: latest_version)
      end
    end

    def self.get_latest_version
      response = request(path: base_url + "api/versions.json")
      response[0]
    end

    private

    def self.extract_data(version:)
      Gem::Package::TarReader.new(Zlib::GzipReader.open dir_raw.join(version)) do |tar|
        tar.rewind
        tar.each do |entry|
          Riot::AssetService.handle_entry(version: version, entry: entry)
        end
      end
    end

    def self.download_raw(version:)
      FileUtils.rm_r Dir.glob(dir_raw.join("*"))

      uri = URI(base_url + "cdn/dragontail-#{version}.tgz")

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        File.open(dir_raw + version, "wb") do |file|
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

    def self.outdated?(latest_version:)
      Dir.children(dir_raw).empty? || Dir.children(dir_raw).first != latest_version
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
