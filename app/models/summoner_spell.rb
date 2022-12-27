# frozen_string_literal: true

class SummonerSpell < ApplicationRecord
  def image_path
    "spells/#{internal_name}.png"
  end
end
