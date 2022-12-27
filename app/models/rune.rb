# frozen_string_literal: true

class Rune < ApplicationRecord
  default_scope { order(:row, :row_order) }

  belongs_to :rune_tree

  enum row: {
    keystone: 0,
    row_1: 1,
    row_2: 2,
    row_3: 3
  }

  def image_path
    "runes/#{file_name}"
  end
end
