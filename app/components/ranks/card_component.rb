class Ranks::CardComponent < ApplicationComponent
  def initialize(summoner:, flex_rank: false)
    @summoner = summoner
    @flex_rank = flex_rank

    @rank = @flex_rank ? summoner.flex_rank : summoner.rank
  end

  def rank_type
    if @flex_rank
      "Flex"
    else
      "Solo/Duo"
    end
  end
end
