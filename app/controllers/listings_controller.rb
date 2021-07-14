# frozen_string_literal: true

class ListingsController < AdminController
  before_action :set_listing, only: %i[show edit update destroy match match_confirm]

  def index # rubocop:todo Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength
    @listings = Listing.all

    # contribution_type filter
    @contribution_types = Contribution::TYPES.map(&:to_s)
    if params[:contribution_type].present? && @contribution_types.include?(params[:contribution_type])
      @listings = @listings.public_send(params[:contribution_type].downcase.pluralize)
    end

    # follow_up_status filter
    @match_statuses = Listing::MATCH_STATUSES.map { |s| [s.titleize, s] }
    if params[:match_status].present?
      @listings = @listings.match_status(params[:match_status])
    end

    # person_id filter
    @people = Person.all.map { |p| [p.name, p.id] }.sort_by(&:first)
    if params[:person_id].present?
      person_id = Person.find(params[:person_id])&.id # verify the person is in the db
      @listings = @listings.person_id(person_id)
    end

    # created_on filter
    @dates = Listing.order(created_at: :desc).pluck(:created_at).map(&:to_date).uniq
    if params[:created_on].present?
      @listings = @listings.created_on(params[:created_on])
    end

    # location_id filter
    if params[:location_id].present?
      @listings = @listings.location_id(params[:location_id])
    end

    # service_area filter
    @service_area_names = ServiceArea.order(:name).map(&:name)
    if params[:service_area_name].present?
      @listings = @listings.service_area_name(params[:service_area_name])
    end
  end

  def match
    listing_type = @listing.type
    match_polymorphic_params = listing_type == Ask ? {receiver: @listing} : {provider: @listing}
    @match = Match.new
    @match.update(match_polymorphic_params)
    @possible_providers = Listing.offers # TODO: - get this to be a filtered list -- need to add logic by which to match
  end

  def match_confirm
    @match = Match.first # TODO: - implement match id here
  end

  def show; end

  def new
    @listing = Listing.new
    set_form_dropdowns
  end

  def edit
    set_form_dropdowns
  end

  def create
    @listing = Listing.new(listing_params)
    if @listing.save
      redirect_to thank_you_path, notice: 'Listing was successfully created.'
    else
      set_form_dropdowns
      render :new
    end
  end

  def update
    if @listing.save
      redirect_to listings_path, notice: 'Listing was successfully updated.'
    else
      set_form_dropdowns
      render :edit
    end
  end

  def destroy
    @listing.destroy
    redirect_to listings_url, notice: 'Listing was successfully destroyed.'
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def set_form_dropdowns
    @available_tags = Category.visible.pluck(:name) + @listing&.tag_list || []
  end

  def listing_params
    params.require(:listing).permit(
      :description,
      :inexhaustible,
      :location_id,
      :person_id,
      :service_area_id,
      :state,
      :submission_id,
      :title,
      :type,
      tag_list: []
    )
  end

  def allowed_params
    @allowed_params ||= params.permit(:format, **BrowseFilter::ALLOWED_PARAMS)
  end

  def filter_params
    return {} unless allowed_params && allowed_params.to_h.any?

    allowed_params.to_h.filter { |key, _v| BrowseFilter::ALLOWED_PARAMS.key? key }.tap do |hash|
      hash.keys.each { |key| hash[key] = hash[key].keys }
    end
  end
end
