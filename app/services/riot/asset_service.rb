# frozen_string_literal: true

module Riot
  class AssetService
    def self.update!
      latest_version = Riot::DDragonService.latest_version
      if outdated?(latest_version: latest_version)
        download_raw(version: latest_version)
        extract_data(version: latest_version)
        update_assets!
      end
    end

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
      elsif entry.full_name.start_with? "img/perk-images/StatMods/"
        img_stats(entry: entry)
      elsif entry.full_name.start_with? "img/perk-images/Styles/"
        img_runes(entry: entry)
      elsif entry.full_name == "#{version}/data/en_US/championFull.json"
        data_champions(entry: entry)
      elsif entry.full_name == "#{version}/data/en_US/item.json"
        data_items(entry: entry)
      elsif entry.full_name == "#{version}/data/en_US/runesReforged.json"
        data_runes(entry: entry)
      elsif entry.full_name == "#{version}/data/en_US/summoner.json"
        data_summoners(entry: entry)
      end
    end

    def self.update_assets!
      update_summoner_spells!
      update_champions!
      update_items!
      update_runes!
    end

    private

    def self.update_runes!
      File.open dir_data.join("runes.json") do |file|
        rune_trees = JSON.load file
        rune_trees.each do |rune_tree_data|
          rune_tree = RuneTree.find_or_initialize_by(id: rune_tree_data["id"])
          rune_tree.update!(
            name: rune_tree_data["name"],
            file_name: rune_tree_data["icon"].split("/").last
          )

          rune_tree_data["slots"].each_with_index do |row, index|
            runes = row["runes"]
            runes.each_with_index do |rune_data, row_order|
              rune = Rune.find_or_initialize_by(id: rune_data["id"])
              rune.update!(
                name: rune_data["name"],
                rune_tree: rune_tree,
                row: index,
                row_order: row_order,
                description: rune_data["shortDesc"],
                file_name: rune_data["icon"].split("/").last
              )
            end
          end
        end
      end
    end

    def self.update_items!
      File.open dir_data.join("items.json") do |file|
        data = JSON.load file
        data = data["data"]
        data.each do |id, item_data|
          item = Item.find_or_initialize_by(id: id)

          type = if item_data["description"].include?("<ornnBonus>")
            :ornn_upgrade
          elsif item_data["description"].include?("<rarityMythic>")
            :mythic
          else
            :basic
          end

          item.update!(
            name: item_data["name"],
            description: item_data["description"].delete_suffix("<br>"),
            cost: item_data["gold"]["total"],
            sell_value: item_data["gold"]["sell"],
            item_type: type
          )
        end
      end

      Item.find_or_create_by!(id: 0)
    end

    def self.update_champions!
      File.open dir_data.join("champions.json") do |file|
        data = JSON.load file
        data = data["data"]
        data.values.each do |champion_data|
          champion = Champion.find_or_initialize_by(id: champion_data["key"])
          champion.update!(
            name: champion_data["name"],
            title: champion_data["title"],
            internal_name: champion_data["id"],
            lore: champion_data["lore"],
            tags: champion_data["tags"]
          )

          passive_data = champion_data["passive"]
          passive = Spell.find_or_initialize_by(champion: champion, spell_type: :passive)
          passive.update!(
            name: passive_data["name"],
            internal_name: passive_data["image"]["full"].delete_suffix(".png"),
            description: passive_data["description"]
          )

          champion_data["spells"].each_with_index do |spell_data, index|
            spell_type = Spell.spell_types.key(index)
            spell = Spell.find_or_initialize_by(champion: champion, spell_type: spell_type)
            spell.update!(
              name: spell_data["name"],
              internal_name: spell_data["id"],
              description: spell_data["description"]
            )
          end
        end
      end
    end

    def self.update_summoner_spells!
      File.open dir_data.join("summoner_spells.json") do |file|
        data = JSON.load file
        data = data["data"]
        data.values.each do |summoner_spell_data|
          summoner_spell = SummonerSpell.find_or_initialize_by(id: summoner_spell_data["key"])
          summoner_spell.update!(
            name: summoner_spell_data["name"],
            internal_name: summoner_spell_data["id"],
            description: summoner_spell_data["description"],
            cooldown: summoner_spell_data["cooldown"].first
          )
        end
      end
    end

    def self.data_summoners(entry:)
      write_to_file(destination: dir_data.join("summoner_spells.json"), entry: entry)
    end

    def self.data_runes(entry:)
      write_to_file(destination: dir_data.join("runes.json"), entry: entry)
    end

    def self.data_items(entry:)
      write_to_file(destination: dir_data.join("items.json"), entry: entry)
    end

    def self.data_champions(entry:)
      write_to_file(destination: dir_data.join("champions.json"), entry: entry)
    end

    def self.img_runes(entry:)
      write_to_file(destination: dir_images.join("runes", file_name(entry: entry)), entry: entry)
    end

    def self.img_stats(entry:)
      write_to_file(destination: dir_images.join("stats", file_name(entry: entry)), entry: entry)
    end

    def self.img_spell(entry:)
      write_to_file(destination: dir_images.join("spells", file_name(entry: entry)), entry: entry)
    end

    def self.img_passive(entry:)
      write_to_file(destination: dir_images.join("passives", file_name(entry: entry)), entry: entry)
    end

    def self.img_profileicon(entry:)
      write_to_file(destination: dir_images.join("profile_icons", file_name(entry: entry)), entry: entry)
    end

    def self.img_item(entry:)
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
      entry.full_name.split("/").last
    end

    def self.dir_images
      Rails.root.join("vendor", "assets", "images")
    end

    def self.dir_data
      Rails.root.join("vendor", "assets", "data")
    end

    def self.dir_raw
      Rails.root.join("vendor", "assets", "raw")
    end

    def self.extract_data(version:)
      Gem::Package::TarReader.new(Zlib::GzipReader.open dir_raw.join(version)) do |tar|
        tar.rewind
        tar.each do |entry|
          Riot::AssetService.handle_entry(version: version, entry: entry)
        end
      end
    end

    def self.download_raw(version:)
      FileUtils.rm Dir.glob(dir_raw.join("*"))

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
  end
end
