class SummonerService
  def self.get_summoner_by_name(region:, name:)
    begin
      name = name.gsub(/\+/, " ")
      summoner = Summoner.create_with(name: name).by_name(name).find_or_initialize_by(region: region)

      if summoner.new_record?
        initialize_summoner(summoner: summoner)
      else
        summoner
      end
    rescue StandardError
      nil
    end
  end

  def self.initialize_summoner(summoner:)
    summoner_object = Riot::ApiService.get_summoner_by_name(region: summoner.region, name: summoner.name)

    summoner_params = construct_params(summoner_object: summoner_object)

    if summoner.update(summoner_params)
      summoner
    else
      existing_summoner = Summoner.find_by(puuid: summoner.puuid)
      summoner_params[:region] = summoner.region
      existing_summoner.update(summoner_params)
      existing_summoner
    end
  end

  def self.update_summoner(summoner:)
    summoner_object = Riot::ApiService.get_summoner_by_puuid(region: summoner.region, puuid: summoner.puuid)

    summoner_params = construct_params(summoner_object: summoner_object)
    summoner.update!(summoner_params)    
  end

  private

  def self.construct_params(summoner_object:)
    {
      name: summoner_object["name"],
      encrypted_id: summoner_object["id"],
      puuid: summoner_object["puuid"],
      profile_icon_id: summoner_object["profileIconId"],
      level: summoner_object["summonerLevel"]
    }
  end
end
