class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]

  def index
    @matches = Match.order(updated_at: :desc)
  end

  def show
  end

  def new
    @match = Match.new
    set_form_dropdowns
  end

  def edit
  end

  def create
    @match = Match.new(match_params)

    respond_to do |format|
      if @match.save
        format.html { redirect_to matches_path, notice: 'Match was successfully created.' }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to matches_path, notice: 'Match was successfully updated.' }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def set_form_dropdowns
      type = params["receiver_id"].present? ? "Ask" : "Offer" # TODO change w resources
      if type == "Ask"
        @receiver = Listing.where(type: type, id: params[:receiver_id]).first
      elsif type == "Offer"
        @provider = Listing.where(type: type, id: params[:provider_id]).first
      end
    end

    def match_params
      params.require(:match).permit(
          :receiver_id,
          :provider_id,
          :receiver_type,
          :provider_type,
          :status,
          :notes,
          :tentative,
          :completed)
    end
end
