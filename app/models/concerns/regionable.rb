module Regionable
  extend ActiveSupport::Concern

  included do
    enum region: {
      na1: 0,
      euw1: 1,
      eun1: 2,
      kr: 3,
      jp1: 4,
      oc1: 5,
      la1: 6,
      la2: 7,
      tr1: 8,
      br1: 9,
      ru: 10
    }
  end
end