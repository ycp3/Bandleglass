class MatchesController < ApplicationController
  before_action :set_match

  def show
  end

  private

  def set_match
    @match = Match.find_by(match_id: params[:match_id])
  end
end
