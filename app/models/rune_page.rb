class RunePage < ApplicationRecord
  belongs_to :participant
  belongs_to :primary_tree, class_name: :RuneTree
  belongs_to :secondary_tree, class_name: :RuneTree

  has_one :keystone, -> { keystone }, through: :primary_tree, source: :runes

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
