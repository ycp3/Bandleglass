class SummonerService
  def self.get_summoner_by_name(region:, name:)
    begin
      Summoner.find_or_create_by(region: region, name: name) do |summoner|
        update_summoner(summoner: summoner)
      end
    rescue Riot::ApiService::NotFoundError
      nil
    end
  end

  def self.update_summoner(summoner:)
    summoner_object = Riot::ApiService.get_summoner_by_name(region: summoner.region, name: summoner.name)

    summoner.update(
      encrypted_id: summoner_object["id"],
      puuid: summoner_object["puuid"],
      profile_icon_id: summoner_object["profileIconId"],
      level: summoner_object["summonerLevel"]
    )
  end
end
