class Spell < ApplicationRecord
  enum spell_type: {
    q: 0,
    w: 1,
    e: 2,
    r: 3,
    passive: 4
  }
end
