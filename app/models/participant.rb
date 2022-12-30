class Participant < ApplicationRecord
  belongs_to :summoner
  belongs_to :team
  belongs_to :match

  belongs_to :champion

  has_many :participant_items
  has_many :items, through: :participant_items

  has_one :rune_page
  has_one :performance

  enum position: {
    top: 0,
    jungle: 1,
    middle: 2,
    bottom: 3,
    support: 4
  }
end
