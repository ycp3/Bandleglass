# frozen_string_literal: true

module Riot
  class AssetsService
    def self.handle_entry(version:, entry:)
      return if entry.directory?
      if entry.full_name.start_with? "#{version}/img/champion/"
        img_champion(entry: entry)
      elsif entry.full_name.start_with? "#{version}/img/item/"
        img_item(entry: entry)
      elsif entry.full_name.start_with? "#{version}/img/profileicon/"
        img_profileicon(entry: entry)
      elsif entry.full_name.start_with? "#{version}/img/passive/"
        img_passive(entry: entry)
      elsif entry.full_name.start_with? "#{version}/img/spell/"
        img_spell(entry: entry)
      end
    end

    private

    def img_spell(entry:)
      write_to_file(destination: dir_images.join("spells", file_name(entry: entry)), entry: entry)
    end

    def img_passive(entry:)
      write_to_file(destination: dir_images.join("passives", file_name(entry: entry)), entry: entry)
    end

    def img_profileicon(entry:)
      write_to_file(destination: dir_images.join("profile_icons", file_name(entry: entry)), entry: entry)
    end

    def img_item(entry:)
      write_to_file(destination: dir_images.join("items", file_name(entry: entry)), entry: entry)
    end

    def self.img_champion(entry:)
      write_to_file(destination: dir_images.join("champion_icons", file_name(entry: entry)), entry: entry)
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
