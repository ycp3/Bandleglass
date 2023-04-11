# frozen_string_literal: true

class Matches::CardComponent < ApplicationComponent
  with_collection_parameter :match

  def initialize(match:, summoner:)
    @match = match
    @participant = match.participants.find_by(summoner: summoner)
    @team = @participant.team
  end

  def result_text
    if @match.remake?
      "REMAKE"
    elsif @team.win
      "WIN"
    else
      "LOSS"
    end
  end

  def result_text_class
    if @match.remake?
      "text-sm md:text-base"
    else
      "text-lg md:text-2xl"
    end
  end

  def bg_class
    if @match.remake?
      "bg-neutral-400/80"
    elsif @team.win
      "bg-blue-400/80"
    else
      "bg-red-400/80"
    end
  end

  def dark_bg_class
    if @match.remake?
      "bg-neutral-700"
    elsif @team.win
      "bg-blue-900"
    else
      "bg-red-900"
    end
  end

  def border_class
    if @match.remake?
      "border-neutral-500"
    elsif @team.win
      "border-blue-500"
    else
      "border-red-500"
    end
  end

  def text_class
    if @match.remake?
      "text-neutral-700"
    elsif @team.win
      "text-blue-900"
    else
      "text-red-900"
    end
  end

  def item_border_class(item:)
    if item.ornn_upgrade?
      "outline outline-3 outline-orange-600"
    elsif item.mythic?
      "outline outline-3 outline-yellow-400"
    end
  end
end
