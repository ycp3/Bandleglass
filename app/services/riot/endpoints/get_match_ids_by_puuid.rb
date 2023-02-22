# frozen_string_literal: true

require "net/http"

module Riot
  class Endpoints::GetMatchIdsByPuuid < Endpoints::Base
    @limits = {}
    @mutex = Mutex.new

    def self.call(region:, puuid:, start: nil, count: nil, queue_type_id: nil)
      path = base_url(region: region) + "lol/match/v5/matches/by-puuid/#{puuid}/ids"
      path = add_params(
        path: path,
        start: start,
        count: count,
        queue_type_id: queue_type_id
      )
      request(region: region, path: path)
    end
  end
end
