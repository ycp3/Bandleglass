class SummonersController < ApplicationController
  before_action :set_summoner, only: %i[ show edit update destroy ]

  # GET /summoners or /summoners.json
  def index
    @summoners = Summoner.all
  end

  # GET /summoners/1 or /summoners/1.json
  def show
  end

  # GET /summoners/new
  def new
    @summoner = Summoner.new
  end

  # GET /summoners/1/edit
  def edit
  end

  # POST /summoners or /summoners.json
  def create
    @summoner = Summoner.new(summoner_params)

    respond_to do |format|
      if @summoner.save
        format.html { redirect_to summoner_url(@summoner), notice: "Summoner was successfully created." }
        format.json { render :show, status: :created, location: @summoner }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @summoner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /summoners/1 or /summoners/1.json
  def update
    respond_to do |format|
      if @summoner.update(summoner_params)
        format.html { redirect_to summoner_url(@summoner), notice: "Summoner was successfully updated." }
        format.json { render :show, status: :ok, location: @summoner }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @summoner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /summoners/1 or /summoners/1.json
  def destroy
    @summoner.destroy

    respond_to do |format|
      format.html { redirect_to summoners_url, notice: "Summoner was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_summoner
      @summoner = Summoner.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def summoner_params
      params.fetch(:summoner, {})
    end
end
