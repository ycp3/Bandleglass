# frozen_string_literal: true

class Participant < ApplicationRecord
  belongs_to :summoner
  belongs_to :team
  belongs_to :match

  belongs_to :champion
  belongs_to :summoner_spell_1, class_name: :SummonerSpell
  belongs_to :summoner_spell_2, class_name: :SummonerSpell

  has_one :rune_page, dependent: :destroy
  has_one :performance, dependent: :destroy

  has_many :participant_items, -> { order(:slot) }, dependent: :destroy
  has_many :items, through: :participant_items

  enum position: {
    top: 0,
    jungle: 1,
    middle: 2,
    bottom: 3,
    support: 4
  }

  scope :load_all, -> {
    includes(
      :team, :performance, :items, :champion, :summoner, :summoner_spell_1, :summoner_spell_2, :match,
      rune_page: [:keystone, primary_tree: :runes, secondary_tree: :runes]
    )
  }

  def kda
    deaths.zero? ? "Perfect" : ((kills + assists) / deaths.to_f).round(2)
  end

  def kill_participation
    ((kills + assists) * 100 / team.kills).round(1) rescue 0
  end

  def cs_per_min
    (cs / (match.duration / 60.0)).round(1)
  end
end
