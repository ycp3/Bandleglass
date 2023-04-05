class Team < ApplicationRecord
  belongs_to :match

  has_many :participants, dependent: :destroy

  enum side: {
    blue: 100,
    red: 200
  }

  def kills
    participants.sum(:kills)
  end
end
