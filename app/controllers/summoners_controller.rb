class SummonersController < ApplicationController
  before_action :set_summoner

  def show
    @text = @summoner.to_s if @summoner.present?
  end

  private

  def set_summoner
    begin
      @summoner = Riot::ApiService.get_summoner_by_name(region: params[:region], name: params[:name])
    rescue Riot::ApiService::NotFoundError
      @text = "summoner not found"
    rescue => error
      @text = error.message
    end
  end
end
