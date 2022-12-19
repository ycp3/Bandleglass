# frozen_string_literal: true

module Riot
  class AssetService
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
    end

    private

    def self.update_items!
      File.open dir_data.join("items.json") do |file|
        data = JSON.load file
        data = data["data"]
        data.each do |id, item_data|
          item = Item.find_or_initialize_by(id: id)
          item.update!(
            name: item_data["name"],
            description: item_data["description"],
            cost: item_data["gold"]["total"],
            sell_value: item_data["gold"]["sell"],
            ornn_upgrade: item_data["requiredAlly"] == "Ornn"
          )
        end
      end
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
  end
end
