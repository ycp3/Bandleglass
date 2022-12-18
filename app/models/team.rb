class Team < ApplicationRecord
  belongs_to :match

  enum side: {
    blue: 100,
    red: 200
  }
end
