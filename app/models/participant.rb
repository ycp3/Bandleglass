class Participant < ApplicationRecord
  belongs_to :summoner
  belongs_to :team
  belongs_to :match

  belongs_to :champion
  belongs_to :summoner_spell_1, class_name: :SummonerSpell
  belongs_to :summoner_spell_2, class_name: :SummonerSpell

  has_one :rune_page, dependent: :destroy
  has_one :performance, dependent: :destroy

  has_many :participant_items, -> { order(:slot) }, dependent: :destroy
  has_many :items, through: :participant_items

  enum position: {
    top: 0,
    jungle: 1,
    middle: 2,
    bottom: 3,
    support: 4
  }
end
