# frozen_string_literal: true

require "net/http"

module Riot
  class Endpoints::GetSummonerByName < Endpoints::Base
    @limits = {}
    @mutex = Mutex.new

    def self.call(region:, name:)
      path = base_url(region: region) + "lol/summoner/v4/summoners/by-name/" + name.gsub(" ", "%20")
      request(region: region, path: path)
    end
  end
end
