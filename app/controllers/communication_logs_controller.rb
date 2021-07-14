# frozen_string_literal: true

class CommunicationLogsController < AdminController
  before_action :set_communication_log, only: %i[show edit update destroy]

  def index
    @communication_logs = CommunicationLog
      .includes(:delivery_method, :person)
      .references(:delivery_method, :person)
      .order(sent_at: :desc)
  end

  def show; end

  def new
    @communication_log = CommunicationLog.new
    set_form_dropdowns
  end

  def edit
    set_form_dropdowns
  end

  def create # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    @communication_log = CommunicationLog.new(communication_log_params)

    if @communication_log.save
      if params[:commit]&.include?('Save and go to Match')
        redirect_to edit_match_path(@communication_log.match), notice: 'Communication log was successfully created.'
      elsif params[:commit]&.include?('Save and go to Respond')
        redirect_to contribution_path(params[:communication_log][:contribution_id]), notice: 'Communication log was successfully created.'
      else
        redirect_to communication_logs_path, notice: 'Communication log was successfully created.'
      end
    else
      set_form_dropdowns
      render :new
    end
  end

  def create_remote
    @communication_log = CommunicationLog.new(communication_log_params)

    if @communication_log.save
      render @communication_log, layout: false
    else
      render :new
    end
  end

  def update # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    if @communication_log.update(communication_log_params)
      if params[:commit]&.include?('Save and go to Match')
        redirect_to edit_match_path(@communication_log.match), notice: 'Communication log was successfully updated.'
      elsif params[:commit]&.include?('Save and go to Respond')
        redirect_to contribution_path(params[:communication_log][:contribution_id]), notice: 'Communication log was successfully updated.'
      else
        redirect_to communication_logs_path, notice: 'Communication log was successfully updated.'
      end
    else
      set_form_dropdowns
      render :edit
    end
  end

  def destroy
    @communication_log.destroy
    redirect_to communication_logs_url, notice: 'Communication log was successfully destroyed.'
  end

  private

  def set_communication_log
    @communication_log = CommunicationLog.find(params[:id])
  end

  def set_form_dropdowns # rubocop:disable Metrics/AbcSize
    @delivery_method_id = if params[:delivery_method_name].present?
      ContactMethod.where('LOWER(name) = ?', params[:delivery_method_name].downcase).last&.id
    else
      ContactMethod.where('LOWER(name) = ?', 'call').last&.id
    end
    @person = @communication_log.person || Person.where(id: params[:person_id]).last
    @match = @communication_log.match || Match.where(id: params[:match_id]).last
    @contribution = Listing.where(id: params[:contribution_id]).last
  end

  def communication_log_params
    params.require(:communication_log).permit(
      :person_id,
      :match_id,
      :body,
      :created_by_id,
      :delivery_method_id,
      :delivery_status,
      :needs_follow_up,
      :outbound,
      :sent_at,
      :subject,
      :auto_generated
    )
  end
end
