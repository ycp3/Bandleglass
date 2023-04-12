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

  def rank_text_class
    if @rank.iron?
      "text-stone-800"
    elsif @rank.bronze?
      "text-orange-900"
    elsif @rank.silver?
      "text-slate-400"
    elsif @rank.gold?
      "text-yellow-500"
    elsif @rank.platinum?
      "text-emerald-600"
    elsif @rank.diamond?
      "text-blue-500"
    elsif @rank.master?
      "text-fuchsia-500"
    elsif @rank.grandmaster?
      "text-red-600"
    elsif @rank.challenger?
      "text-sky-300"
    end
  end
end
