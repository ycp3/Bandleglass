# frozen_string_literal: true

class Spell < ApplicationRecord
  belongs_to :champion

  enum spell_type: {
    q: 0,
    w: 1,
    e: 2,
    r: 3,
    passive: 4
  }

  def image_path
    if passive?
      "passives/#{internal_name}.png"
    else
      "spells/#{internal_name}.png"
    end
  end
end
