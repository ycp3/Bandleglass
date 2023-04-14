# frozen_string_literal: true

class Summoner < ApplicationRecord
  include Regionable

  validates :puuid, uniqueness: true
  validates :name, uniqueness: { scope: :region, message: "Summoner already exists for this region." }

  scope :by_name, ->(name) { where("lower(name) = ?", name.strip.downcase) }

  has_many :participants
  has_many :teams, through: :participants
  has_many :matches, through: :participants

  has_many :ranks, dependent: :destroy

  def rank
    ranks.find_by queue_type: :ranked_solo_5x5
  end
  
  def flex_rank
    ranks.find_by queue_type: :ranked_flex_sr
  end

  def winrate
    (teams.joins(:match).where.not(match: { ended_by: :remake }).where(win: true).count * 100 / teams.joins(:match).where.not(match: { ended_by: :remake }).count.to_f).round(1)
  end

  def most_played_champion
    participants.group(:champion_id).select(:champion_id).order(Arel.sql("COUNT(*) DESC")).first.champion
  end

  def image_path
    "profile_icons/#{profile_icon_id}.png"
  end
end
