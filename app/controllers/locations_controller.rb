# frozen_string_literal: true

class LocationsController < AdminController
  before_action :set_location, only: %i[show edit update destroy]

  def index # rubocop:todo Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength
    @locations = Location.order(:state, :city, :region, :neighborhood, :street_address)

    # service_area filter
    @service_area_names = ServiceArea.order(:name).map(&:name)
    if params[:service_area_name].present?
      @locations = @locations.service_area_name(params[:service_area_name])
    end

    # street_address filter
    if params[:street_address].present?
      @locations = @locations.street_address(params[:street_address])
    end

    # city filter
    if params[:city].present?
      @locations = @locations.city(params[:city])
    end

    # location_types filter
    @location_type_names = LocationType.order(:name).map(&:name)
    if params[:location_type_name].present?
      @locations = @locations.location_type_name(params[:location_type_name])
    end

    # person_id filter
    @people = Person.all.map { |p| [p.name, p.id] }.sort_by(&:first)
    if params[:person_id].present?
      person_id = Person.find(params[:person_id])&.id # verify the person is in the db
      @locations = @locations.person_id(person_id)
    end
  end

  def show; end

  def new
    @location = Location.new
    set_form_dropdowns
  end

  def edit
    set_form_dropdowns
  end

  def create
    @location = Location.new(location_params)

    if @location.save
      redirect_to locations_path, notice: 'Location was successfully created.'
    else
      set_form_dropdowns
      render :new
    end
  end

  def update
    if @location.update(location_params)
      redirect_to locations_path, notice: 'Location was successfully updated.'
    else
      set_form_dropdowns
      render :edit
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_path, notice: 'Location was successfully destroyed.'
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def set_form_dropdowns
    @service_areas = ServiceArea.all.map { |t| [t.full_name, t.id] }.sort_by(&:first)
  end

  def location_params
    params.require(:location).permit(
      :location_type_id,
      :street_address,
      :city,
      :state,
      :zip,
      :county,
      :region,
      :neighborhood
    )
  end
end
