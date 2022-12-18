# frozen_string_literal: true

class Champion < ApplicationRecord
  has_many :spells, -> { order(:spell_type) }

  def name_and_title
    "#{name}, #{title}"
  end

  def q
    spells.first
  end

  def w
    spells.second
  end

  def e
    spells.third
  end

  def r
    spells.fourth
  end

  def passive
    spells.fifth
  end

  def image_path
    "champion_icons/#{internal_name}.png"
  end
end
