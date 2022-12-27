class ParticipantItem < ApplicationRecord
  belongs_to :participant
  belongs_to :item

  enum slot: {
    slot_1: 0,
    slot_2: 1,
    slot_3: 2,
    slot_4: 3,
    slot_5: 4,
    slot_6: 5,
    trinket: 6
  }
end
