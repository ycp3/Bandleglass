class Summoner < ApplicationRecord
  include Regionable

  validates :puuid, uniqueness: true
  validates :name, uniqueness: { scope: :region, message: "Summoner already exists for this region." }

  scope :by_name, ->(name) { where("lower(name) = ?", name.strip.downcase) }
end
