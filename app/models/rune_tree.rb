# frozen_string_literal: true

class RuneTree < ApplicationRecord
  has_many :runes

  def image_path
    "runes/#{file_name}"
  end
end
