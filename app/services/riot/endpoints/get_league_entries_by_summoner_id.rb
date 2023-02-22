# frozen_string_literal: true

require "net/http"

module Riot
  class Endpoints::GetLeagueEntriesBySummonerId < Endpoints::Base
    @limits = {}
    @mutex = Mutex.new

    def self.call(region:, summoner_id:)
      path = base_url(region: region) + "lol/league/v4/entries/by-summoner/" + summoner_id
      request(region: region, path: path)
    end
  end
end
