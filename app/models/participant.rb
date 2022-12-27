class Participant < ApplicationRecord
  belongs_to :summoner
  belongs_to :team
  belongs_to :match

  belongs_to :champion
  belongs_to :ban, class_name: :Champion

  has_many :participant_items
  has_many :items, through: :participant_items

  has_one :rune_page
end
