# frozen_string_literal: true

class Rank < ApplicationRecord
  belongs_to :summoner

  enum tier: {
    iron: 0,
    bronze: 1,
    silver: 2,
    gold: 3,
    platinum: 4,
    diamond: 5,
    master: 6,
    grandmaster: 7,
    challenger: 8
  }

  enum division: {
    I: 0,
    II: 1,
    III: 2,
    IV: 3
  }

  def to_s
    if master_tier?
      "#{tier.titleize} (#{lp}LP)"
    else
      "#{tier.titleize} #{division} (#{lp}LP)"
    end
  end

  def master_tier?
    master? || grandmaster? || challenger?
  end
end
