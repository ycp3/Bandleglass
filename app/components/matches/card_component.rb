# frozen_string_literal: true

class Matches::CardComponent < ApplicationComponent
  with_collection_parameter :match

  def initialize(match:, summoner:)
    @match = match
    @participant = match.participants.find_by(summoner: summoner)
    @team = @participant.team
  end

  def bg_class
    if @team.win
      "bg-blue-400/80"
    else
      "bg-red-400/80"
    end
  end

  def dark_bg_class
    if @team.win
      "bg-blue-900"
    else
      "bg-red-900"
    end
  end

  def border_class
    if @team.win
      "border-blue-500"
    else
      "border-red-500"
    end
  end

  def text_class
    if @team.win
      "text-blue-900"
    else
      "text-red-900"
    end
  end
end
