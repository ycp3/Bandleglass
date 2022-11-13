class SummonersController < ApplicationController
  before_action :set_summoner

  def show
    @summoner = Summoner.first
  end

  private

  def set_summoner
    # TODO
  end
end
