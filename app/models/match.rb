class Match < ApplicationRecord
  include Regionable

  validates :match_id, uniqueness: true

  has_many :participants, through: :teams
  
  has_one :blue_team, -> { blue }, class_name: :Team
  has_one :red_team, -> { red }, class_name: :Team

  enum map: {
    summoners_rift: 11,
    howling_abyss: 12,
    nexus_blitz_map: 21
  }

  enum queue_type: {
    draft_pick: 400,
    ranked_solo: 420,
    blind_pick: 430,
    ranked_flex: 440,
    aram: 450,
    clash: 700,
    intro_bots: 830,
    beginner_bots: 840,
    intermediate_bots: 850,
    arurf: 900,
    one_for_all: 1020,
    nexus_blitz: 1300,
    ultimate_spellbook: 1400,
    urf: 1900,
    tutorial_1: 2000,
    tutorial_2: 2010,
    tutorial_3: 2020
  }

  def finished_at
    started_at + duration.seconds
  end

  def time
    "#{duration / 60}:#{duration % 60}"
  end
end
