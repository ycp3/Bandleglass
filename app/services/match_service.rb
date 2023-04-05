# frozen_string_literal: true

class MatchService
  def self.update_matches_for_summoner(summoner:)
    match_ids = Riot::ApiService.get_match_ids_by_puuid(region: summoner.region, puuid: summoner.puuid).reject { |match_id| Match.exists? match_id: match_id }
    match_data = []
    mutex = Mutex.new
    match_ids.map do |match_id|
      Thread.new do
        data = Riot::ApiService.get_match_by_match_id(region: summoner.region, match_id: match_id)
        mutex.synchronize do
          match_data << data
        end
      end
    end.each(&:join)

    match_data.each { |data| create_match(region: summoner.region, match_data: data) }
  end

  private

  def self.create_match(region:, match_data:)
    match_id = match_data["metadata"]["matchId"]
    match_data = match_data["info"]
    patch = match_data["gameVersion"].split(".")
    patch = "#{patch[0]}.#{patch[1]}"
    match = Match.create!(
      match_id: match_id,
      region: match_data["platformId"].downcase,
      started_at: Time.at(match_data["gameCreation"] / 1000),
      duration: match_data["gameDuration"],
      game_version: patch,
      map: match_data["mapId"],
      queue_type: match_data["queueId"]
    )

    blue_team_data = match_data["teams"].find { |team_data| team_data["teamId"] == Team.sides[:blue] }
    blue_team = Team.create!(
      match: match,
      side: blue_team_data["teamId"],
      win: blue_team_data["win"],
      first_baron: blue_team_data["objectives"]["baron"]["first"],
      baron_kills: blue_team_data["objectives"]["baron"]["kills"],
      first_champion: blue_team_data["objectives"]["champion"]["first"],
      champion_kills: blue_team_data["objectives"]["champion"]["kills"],
      first_dragon: blue_team_data["objectives"]["dragon"]["first"],
      dragon_kills: blue_team_data["objectives"]["dragon"]["kills"],
      first_inhibitor: blue_team_data["objectives"]["inhibitor"]["first"],
      inhibitor_kills: blue_team_data["objectives"]["inhibitor"]["kills"],
      first_rift_herald: blue_team_data["objectives"]["riftHerald"]["first"],
      rift_herald_kills: blue_team_data["objectives"]["riftHerald"]["kills"],
      first_tower: blue_team_data["objectives"]["tower"]["first"],
      tower_kills: blue_team_data["objectives"]["tower"]["kills"],
      banned_champion_ids: blue_team_data["bans"].map { |ban_object| ban_object["championId"] },
      surrendered: match_data["participants"].first["gameEndedInSurrender"] && !blue_team_data["win"]
    )

    red_team_data = match_data["teams"].find { |team_data| team_data["teamId"] == Team.sides[:red] }
    red_team = Team.create!(
      match: match,
      side: red_team_data["teamId"],
      win: red_team_data["win"],
      first_baron: red_team_data["objectives"]["baron"]["first"],
      baron_kills: red_team_data["objectives"]["baron"]["kills"],
      first_champion: red_team_data["objectives"]["champion"]["first"],
      champion_kills: red_team_data["objectives"]["champion"]["kills"],
      first_dragon: red_team_data["objectives"]["dragon"]["first"],
      dragon_kills: red_team_data["objectives"]["dragon"]["kills"],
      first_inhibitor: red_team_data["objectives"]["inhibitor"]["first"],
      inhibitor_kills: red_team_data["objectives"]["inhibitor"]["kills"],
      first_rift_herald: red_team_data["objectives"]["riftHerald"]["first"],
      rift_herald_kills: red_team_data["objectives"]["riftHerald"]["kills"],
      first_tower: red_team_data["objectives"]["tower"]["first"],
      tower_kills: red_team_data["objectives"]["tower"]["kills"],
      banned_champion_ids: red_team_data["bans"].map { |ban_object| ban_object["championId"] },
      surrendered: match_data["participants"].first["gameEndedInSurrender"] && !red_team_data["win"]
    )

    match_data["participants"].each do |participant_data|
      summoner = Summoner.create_with(
        name: participant_data["summonerName"],
        region: match.region,
        encrypted_id: participant_data["summonerId"],
        profile_icon_id: participant_data["profileIcon"],
        level: participant_data["summonerLevel"]
      ).find_or_create_by!(puuid: participant_data["puuid"])

      team = if participant_data["teamId"] == Team.sides[:blue]
        blue_team
      else
        red_team
      end

      # RankService.update_ranks_for_summoner(summoner: summoner)
      # rank = if match.ranked_flex?
      #   summoner.flex_rank
      # else
      #   summoner.rank
      # end
      rank = nil

      position = if participant_data["teamPosition"] == "UTILITY"
        "SUPPORT"
      else
        participant_data["teamPosition"]
      end

      participant = Participant.create!(
        summoner: summoner,
        match: match,
        team: team,
        champion_id: participant_data["championId"],
        summoner_spell_1_id: participant_data["summoner1Id"],
        summoner_spell_2_id: participant_data["summoner2Id"],
        name: participant_data["summonerName"],
        level: participant_data["summonerLevel"],
        profile_icon_id: participant_data["profileIcon"],
        cached_tier: rank&.tier,
        cached_division: rank&.division,
        cached_lp: rank&.lp,
        kills: participant_data["kills"],
        deaths: participant_data["deaths"],
        assists: participant_data["assists"],
        champion_level: participant_data["champLevel"],
        champion_transform: participant_data["championTransform"],
        position: position.downcase,
        gold_earned: participant_data["goldEarned"],
        largest_multikill: participant_data["largestMultiKill"],
        damage_dealt: participant_data["totalDamageDealtToChampions"],
        damage_taken: participant_data["totalDamageTaken"],
        cs: participant_data["totalMinionsKilled"] + participant_data["neutralMinionsKilled"],
        vision_score: participant_data["visionScore"]
      )

      Performance.create!(
        participant: participant,
        baron_kills: participant_data["baronKills"],
        dragon_kills: participant_data["dragonKills"],
        xp: participant_data["champExperience"],
        objective_damage: participant_data["damageDealtToObjectives"],
        turret_damage: participant_data["damageDealtToTurrets"],
        objectives_stolen: participant_data["objectivesStolen"],
        largest_killing_spree: participant_data["largestKillingSpree"],
        largest_critical_strike: participant_data["largestCriticalStrike"],
        physical_damage_dealt: participant_data["physicalDamageDealtToChampions"],
        physical_damage_taken: participant_data["physicalDamageTaken"],
        magic_damage_dealt: participant_data["magicDamageDealtToChampions"],
        magic_damage_taken: participant_data["magicDamageTaken"],
        true_damage_dealt: participant_data["trueDamageDealtToChampions"],
        true_damage_taken: participant_data["trueDamageTaken"],
        self_mitigated_damage: participant_data["damageSelfMitigated"],
        cc_score: participant_data["timeCCingOthers"],
        control_wards_placed: participant_data["detectorWardsPlaced"],
        stealth_wards_placed: participant_data["wardsPlaced"] - participant_data["detectorWardsPlaced"],
        wards_killed: participant_data["wardsKilled"],
        first_blood_assist: participant_data["firstBloodAssist"],
        first_blood_kill: participant_data["firstBloodKill"],
        first_tower_assist: participant_data["firstTowerAssist"],
        first_tower_kill: participant_data["firstTowerKill"],
        inhibitor_kills: participant_data["inhibitorKills"],
        inhibitor_takedowns: participant_data["inhibitorTakedowns"],
        turret_kills: participant_data["turretKills"],
        turret_takedowns: participant_data["turretTakedowns"],
        gold_spent: participant_data["goldSpent"],
        q_casts: participant_data["spell1Casts"],
        w_casts: participant_data["spell2Casts"],
        e_casts: participant_data["spell3Casts"],
        r_casts: participant_data["spell4Casts"],
        summoner_spell_1_casts: participant_data["summoner1Casts"],
        summoner_spell_2_casts: participant_data["summoner2Casts"]
      )

      rune_page_data = participant_data["perks"]
      primary_tree_data = rune_page_data["styles"].find { |tree_data| tree_data["description"] == "primaryStyle" }
      secondary_tree_data = rune_page_data["styles"].find { |tree_data| tree_data["description"] == "subStyle" }
      RunePage.create!(
        participant: participant,
        primary_tree_id: primary_tree_data["style"],
        keystone_id: primary_tree_data["selections"].first["perk"],
        primary_rune_ids: primary_tree_data["selections"][1..].map { |rune_data| rune_data["perk"] },
        secondary_tree_id: secondary_tree_data["style"],
        secondary_rune_ids: secondary_tree_data["selections"].map { |rune_data| rune_data["perk"] },
        offense_stat: rune_page_data["statPerks"]["offense"],
        flex_stat: rune_page_data["statPerks"]["flex"],
        defense_stat: rune_page_data["statPerks"]["defense"]
      )

      7.times do |index|
        ParticipantItem.create!(
          participant: participant,
          item_id: participant_data["item#{index}"],
          slot: index
        )
      end
    end

    red_team.update!(
      kills: red_team.participants.sum(:kills),
      deaths: red_team.participants.sum(:deaths),
      assists: red_team.participants.sum(:assists)
    )

    blue_team.update!(
      kills: blue_team.participants.sum(:kills),
      deaths: blue_team.participants.sum(:deaths),
      assists: blue_team.participants.sum(:assists)
    )
  end
end
