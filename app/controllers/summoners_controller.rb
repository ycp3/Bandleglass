class SummonersController < ApplicationController
  before_action :set_summoner

  def show
    if @summoner.present?
      @matches = @summoner.matches.order(started_at: :desc).limit(20).load_participants
    else
      redirect_to root_path, notice: "test"
    end
  end

  private

  def set_summoner
    @summoner = SummonerService.get_summoner_by_name(region: params[:region], name: params[:name])
  end
end
