# frozen_string_literal: true

class OffersController < PublicController
  layout 'without_navbar', only: %i[new create]

  def index
    redirect_to contributions_path
  end

  def new
    render_form(Submission.new)
  end

  def create
    submission = SubmissionForm.build submission_params
    if submission.save
      EmailNewSubmission.run! submission: submission, user: current_user
      redirect_to contribution_thank_you_path, notice: 'Offer was successfully created.'
    else
      render_form(submission)
    end
  end

  private

  def submission_params
    params[:submission].tap do |p|
      p[:form_name] = 'Offer_form'
      p[:listings_attributes][:type] = 'Offer'
    end
  end

  def render_form(submission)
    @form = Form.find_by!(contribution_type_name: 'Offer')
    @organization = Organization.current_organization

    @json = {
      submission: SubmissionBlueprint.render_as_hash(submission),
      configuration: ConfigurationBlueprint.render_as_hash(nil),
      form: FormBlueprint.render_as_hash(@form)
    }.to_json

    render :new
  end
end
