class SummonersController < ApplicationController
  before_action :set_summoner

  def show
    if @summoner.present?
      @matches = @summoner.matches.order(started_at: :desc).limit(20).load_participants
    else
      redirect_to root_path, alert: "Summoner not found, check region and spelling and try again!"
    end
  end

  def update_matches
    SummonerService.update_summoner(summoner: @summoner)
    MatchService.update_matches_for_summoner(summoner: @summoner)

    redirect_to summoners_path(@summoner.region, @summoner.name)
  end

  private

  def set_summoner
    @summoner = if params[:summoner_id].present?
      Summoner.find(params[:summoner_id])
    else
      SummonerService.get_summoner_by_name(region: params[:region], name: params[:name])
    end
  end
end
