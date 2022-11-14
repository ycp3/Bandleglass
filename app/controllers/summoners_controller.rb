class SummonersController < ApplicationController
  before_action :set_summoner

  def show
    if @summoner.present?
      @text = "success"
    else
      @text = "error"
    end
  end

  private

  def set_summoner
    @summoner = SummonerService.get_summoner_by_name(region: params[:region], name: params[:name].gsub("+", " "))
  end
end
