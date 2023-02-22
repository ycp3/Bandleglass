# frozen_string_literal: true

require "net/http"

module Riot
  class Endpoints::GetMatchByMatchId < Endpoints::Base
    @limits = {}
    @mutex = Mutex.new

    def self.call(region:, match_id:)
      path = base_url(region: region) + "lol/match/v5/matches/" + match_id
      request(region: region, path: path)
    end
  end
end
