class RunePage < ApplicationRecord
  belongs_to :participant
  belongs_to :primary_tree, class_name: :RuneTree
  belongs_to :secondary_tree, class_name: :RuneTree

  belongs_to :keystone, class_name: :Rune, foreign_key: :keystone_id
  belongs_to :row_1, class_name: :Rune, foreign_key: :row_1_id
  belongs_to :row_2, class_name: :Rune, foreign_key: :row_2_id
  belongs_to :row_3, class_name: :Rune, foreign_key: :row_3_id
  belongs_to :secondary_rune_1, class_name: :Rune, foreign_key: :secondary_rune_1_id
  belongs_to :secondary_rune_2, class_name: :Rune, foreign_key: :secondary_rune_2_id

  scope :load_all, -> {
    includes(
      :primary_tree,
      :keystone,
      :row_1,
      :row_2,
      :row_3,
      :secondary_tree,
      :secondary_rune_1,
      :secondary_rune_2
    )
  }

  STAT_RUNES = {
    health: 5001,
    armor: 5002,
    magic_resist: 5003,
    attack_speed: 5005,
    cooldown_reduction: 5007,
    adaptive_force: 5008
  }

  enum offense_stat: STAT_RUNES, _prefix: :offense
  enum flex_stat: STAT_RUNES, _prefix: :flex
  enum defense_stat: STAT_RUNES, _prefix: :defense
end
