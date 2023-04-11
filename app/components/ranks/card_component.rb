class Ranks::CardComponent < ApplicationComponent
  def initialize(summoner:, flex_rank: false)
    @summoner = summoner

    @rank = flex_rank ? summoner.rank : summoner.flex_rank
  end
end
