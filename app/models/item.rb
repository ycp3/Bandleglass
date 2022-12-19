# frozen_string_literal: true

class Item < ApplicationRecord
  def image_path
    "items/#{id}.png"
  end
end
