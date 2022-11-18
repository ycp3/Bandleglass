class Summoner < ApplicationRecord
  validates :puuid, uniqueness: true
  validates :name, uniqueness: { scope: :region, message: "Summoner already exists for this region." }

  scope :by_name, ->(name) { where("lower(name) = ?", name.strip.downcase) }

  enum region: {
    na1: 0,
    euw1: 1,
    eun1: 2,
    kr: 3,
    jp1: 4,
    oc1: 5,
    la1: 6,
    la2: 7,
    tr1: 8,
    br1: 9,
    ru: 10
  }
end
