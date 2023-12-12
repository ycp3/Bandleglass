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
    if SummonerService.update_summoner(summoner: @summoner)
      RankService.update_ranks_for_summoner(summoner: @summoner)
      matches = MatchService.update_matches_for_summoner(summoner: @summoner)

      Turbo::StreamsChannel.broadcast_replace_to dom_id(@summoner), target: dom_id(@summoner, :header), html: Summoners::HeaderComponent.new(summoner: @summoner).render_in(view_context)
      Turbo::StreamsChannel.broadcast_replace_to dom_id(@summoner), target: dom_id(@summoner, :rank), html: Ranks::CardComponent.new(summoner: @summoner).render_in(view_context)
      Turbo::StreamsChannel.broadcast_replace_to dom_id(@summoner), target: dom_id(@summoner, :flex_rank), html: Ranks::CardComponent.new(summoner: @summoner, flex_rank: true).render_in(view_context)
      Turbo::StreamsChannel.broadcast_update_to dom_id(@summoner), target: dom_id(@summoner, :matches), html: Matches::CardComponent.with_collection(@summoner.matches.order(started_at: :desc).limit(20), summoner: @summoner).render_in(view_context) unless matches.empty?

      redirect_to summoners_path(@summoner.region, @summoner.name), notice: "Summoner updated!"
    else
      redirect_to summoners_path(@summoner.region, @summoner.name), alert: "Summoner not found, check region and search again from the main page!"
    end
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
