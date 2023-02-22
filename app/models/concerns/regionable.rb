module Regionable
  extend ActiveSupport::Concern

  AMERICAS_REGIONS = ["na1", "br1", "la1", "la2"]
  EUROPE_REGIONS = ["euw1", "eun1", "tr1", "ru"]
  ASIA_REGIONS = ["kr", "jp1"]
  SEA_REGIONS = ["oc1", "ph2", "sg2", "th2", "tw2", "vn2"]

  included do
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
      ru: 10,
      ph2: 11,
      sg2: 12,
      th2: 13,
      tw2: 14,
      vn2: 15
    }
  end

  def self.region_to_platform(region:)
    if Regionable::AMERICAS_REGIONS.include? region
      "americas"
    elsif Regionable::EUROPE_REGIONS.include? region
      "europe"
    elsif Regionable::ASIA_REGIONS.include? region
      "asia"
    elsif Regionable::SEA_REGIONS.include? region
      "sea"
    end
  end
end
