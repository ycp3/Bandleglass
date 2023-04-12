# frozen_string_literal: true

class Rank < ApplicationRecord
  belongs_to :summoner

  enum queue_type: {
    ranked_solo_5x5: 0,
    ranked_flex_sr: 1
  }

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
    i: 0,
    ii: 1,
    iii: 2,
    iv: 3
  }

  def to_s
    if master_tier?
      "#{tier.titleize} (#{lp}LP)"
    else
      "#{tier.titleize} #{division.upcase} (#{lp}LP)"
    end
  end

  def master_tier?
    master? || grandmaster? || challenger?
  end

  def winrate
    (wins * 100 / (wins + losses).to_f).round(1)
  end

  def image_path
    "ranks/#{tier}.png"
  end
end
