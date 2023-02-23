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
end
