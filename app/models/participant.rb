class Participant < ApplicationRecord
  belongs_to :summoner
  belongs_to :team
  belongs_to :match

  belongs_to :champion

  has_many :participant_items, dependent: :destroy
  has_many :items, through: :participant_items

  has_one :rune_page, dependent: :destroy
  has_one :performance, dependent: :destroy

  enum position: {
    top: 0,
    jungle: 1,
    middle: 2,
    bottom: 3,
    support: 4
  }
end
