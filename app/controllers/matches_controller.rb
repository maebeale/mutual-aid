# frozen_string_literal: true

class MatchesController < AdminController
  before_action :set_match, only: %i[edit update destroy]

  def index # rubocop:todo Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength
    @matches = Match.status(params[:status] || 'all').order(updated_at: :desc)

    # follow_up_status filter
    @statuses = Match::STATUSES.map { |s| [s.titleize, s] }
    if params[:follow_up_status].present?
      @matches = @matches.follow_up_status(params[:follow_up_status])
    end

    # connected_to_person_id filter
    @people = Person.all.map { |p| [p.name, p.id] }.sort_by(&:first)
    if params[:connected_to_person_id].present?
      person = Person.find(params[:connected_to_person_id])
      @matches = @matches.connected_to_person_id(person)
    end

    # match_ids filter
    if params[:match_ids].present?
      @matches = @matches.match_ids(params[:match_ids])
    end
  end

  def show
    @match = Match.includes(:communication_logs).references(:communication_logs).where(id: params[:id]).last
  end

  def new
    @match = Match.new
    set_form_dropdowns
  end

  def edit
    set_form_dropdowns
  end

  def create # rubocop:todo Metrics/MethodLength
    @match = Match.new(match_params)

    if @match.save
      save_and_continue = params[:commit]&.downcase&.include?('save and view match')
      if save_and_continue
        redirect_to edit_match_path(@match), notice: 'Match was successfully created.'
      else
        redirect_to matches_path, notice: 'Match was successfully created.'
      end
    else
      set_form_dropdowns
      render :new
    end
  end

  def update # rubocop:todo Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength
    save_and_continue = params[:commit]&.downcase&.include?('save and view match')
    update_connections = params[:commit]&.downcase&.include?('edit who this match connects')
    if @match.update(match_params)
      if save_and_continue || update_connections
        redirect_to(
          edit_match_path(@match, edit_connection_mode: !!update_connections),
          notice: 'Match was successfully updated.'
        )
      else
        redirect_to matches_path, notice: 'Match was successfully updated.'
      end
    else
      set_form_dropdowns
      render :edit
    end
  end

  def destroy
    @match.destroy
    redirect_to matches_url, notice: 'Match was successfully destroyed.'
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def set_form_dropdowns # rubocop:todo Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength
    type = params['receiver_id'].present? ? 'Ask' : 'Offer' # TODO: change w resources
    if type == 'Ask'
      @receiver = Listing.where(type: type, id: params[:receiver_id]).first
    elsif type == 'Offer'
      @provider = Listing.where(type: type, id: params[:provider_id]).first
    end

    @matchable_asks = Ask.matchable.map { |a| [a.name_and_match_history.html_safe, a.id] }.sort_by(&:first)
    @matchable_offers = Offer.matchable.map { |o| [o.name_and_match_history.html_safe, o.id] }.sort_by(&:first)

    if @match.receiver_id && @match.provider_id
      # rubocop:todo Lint/SafeNavigationChain (easy enough to fix but these chains are a smell IMO)
      @matched_asks = (@matchable_asks + [[@match.receiver&.name_and_match_history.html_safe, @match.receiver&.id]]).sort_by(&:first)
      @matched_offers = (@matchable_offers + [[@match.provider&.name_and_match_history.html_safe, @match.provider&.id]]).sort_by(&:first)
      # rubocop:enable Lint/SafeNavigationChain
    end
    @statuses = Match::STATUSES.map { |s| [s.titleize, s] }

    @communication_logs = CommunicationLog.where(match: @match)

    @edit_connection_mode = YAML.load(params[:edit_connection_mode].to_s)
  end

  def match_params
    params.require(:match).permit(
      :receiver_id,
      :provider_id,
      :shift_id,
      :receiver_type,
      :provider_type,
      :exchanged_at,
      :status,
      :notes,
      :tentative,
      :completed
    )
  end
end
