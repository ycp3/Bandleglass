# frozen_string_literal: true

class RankService
  def self.update_ranks_for_summoner(summoner:)
    league_entries = Riot::ApiService.get_league_entries_by_summoner_id(region: summoner.region, summoner_id: summoner.encrypted_id)
    league_entries.each do |entry_data|
      queue_type = entry_data["queueType"].downcase
      next unless Rank.queue_types.keys.include? queue_type

      rank = Rank.find_or_initialize_by(summoner: summoner, queue_type: queue_type)
      rank.update!(
        tier: entry_data["tier"].downcase,
        division: entry_data["rank"].downcase,
        lp: entry_data["leaguePoints"],
        wins: entry_data["wins"],
        losses: entry_data["losses"]
      )
    end
  end
end
