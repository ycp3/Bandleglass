class Rune < ApplicationRecord
  belongs_to :rune_tree

  enum row: {
    keystone: 0,
    row_1: 1,
    row_2: 2,
    row_3: 3
  }
end
