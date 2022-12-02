# frozen_string_literal: true

module Riot
  class AssetsService
    def self.handle_entry(version:, entry:)
      return if entry.directory?
      if entry.full_name.start_with? "#{version}/img/champion/"
        img_champion(entry: entry)
      end
    end

    private

    def self.img_champion(entry:)
      write_to_file(destination: dir_images.join("champion", file_name(entry: entry)), entry: entry)
    end

    def self.write_to_file(destination:, entry:)
      File.open(destination, "wb") do |file|
        file.print entry.read
      end
    end

    def self.file_name(entry:)
      entry.full_name.split("/")[-1]
    end

    def self.dir_images
      Rails.root.join("vendor", "assets", "images")
    end

    def dir_data
      Rails.root.join("vendor", "assets", "data")
    end
  end
end
