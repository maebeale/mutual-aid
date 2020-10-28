# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :set_submission, only: %i[show edit update destroy]

  def index
    @submissions = Submission.order(created_at: :desc)
  end

  def show; end

  def new
    @submission = Submission.new
    set_form_dropdowns
  end

  def edit
    set_form_dropdowns
  end

  def create
    @submission = Submission.new(submission_params)

    if @submission.save
      EmailNewSubmission.run! submission: @submission, user: current_user
      redirect_to submissions_path, notice: 'Submission successfully created.'
    else
      set_form_dropdowns
      render :new
    end
  end

  def update
    if @submission.update(submission_params)
      redirect_to submissions_path, notice: 'Submission was successfully updated.'
    else
      set_form_dropdowns
      render :edit
    end
  end

  def destroy
    @submission.destroy
    redirect_to submissions_url, notice: 'Submission was successfully destroyed.'
  end

  private

  def set_submission
    @submission = Submission.find(params[:id])
  end

  def set_form_dropdowns
    @form_names = ['ask_form', 'offer_form', 'community_resources_form', 'announcements_form']
  end

  def submission_params
    params.require(:submission).permit(
      :body,
      :created_at,
      :form_name,
      :person_id,
      :privacy_level_requested,
      :service_area_id,
    )
  end
end
