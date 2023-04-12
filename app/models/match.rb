# frozen_string_literal: true

class Match < ApplicationRecord
  include Regionable

  validates :match_id, uniqueness: true

  has_many :teams, dependent: :destroy
  has_many :participants, through: :teams
  
  has_one :blue_team, -> { blue }, class_name: :Team, dependent: :destroy
  has_one :red_team, -> { red }, class_name: :Team, dependent: :destroy

  scope :load_all, -> {
    includes(
      red_team: { participants: [:items, :summoner, :champion, :summoner_spell_1, :summoner_spell_2, :performance, rune_page: [:keystone, :secondary_tree]] },
      blue_team: { participants: [:items, :summoner, :champion, :summoner_spell_1, :summoner_spell_2, :performance, rune_page: [:keystone, :secondary_tree]] }
    )
  }

  scope :load_participants, -> {
    includes(
      red_team: { participants: [:summoner, :champion] },
      blue_team: { participants: [:summoner, :champion] }
    )
  }

  enum ended_by: {
    remake: 0,
    early_surrender: 1,
    surrender: 2,
    full: 3
  }

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
    "#{duration / 60}:#{format("%02d", duration % 60)}"
  end

  def queue
    aram? ? "ARAM" : queue_type.titleize
  end

  def bots?
    intro_bots? || beginner_bots? || intermediate_bots?
  end
end
