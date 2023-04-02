# frozen_string_literal: true

class Item < ApplicationRecord
  enum item_type: {
    basic: 0,
    mythic: 1,
    ornn_upgrade: 2
  }

  def image_path
    "items/#{id}.png"
  end
end
