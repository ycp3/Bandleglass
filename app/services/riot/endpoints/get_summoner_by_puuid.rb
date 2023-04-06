# frozen_string_literal: true

require "net/http"

module Riot
  class Endpoints::GetSummonerByPuuid < Endpoints::Base
    @limits = {}
    @mutex = Mutex.new

    def self.call(region:, puuid:)
      path = base_url(region: region) + "lol/summoner/v4/summoners/by-puuid/" + puuid
      request(region: region, path: path)
    end
  end
end
