# frozen_string_literal: true

class ContributionBlueprint < Blueprinter::Base
  identifier :id
  association :categories_for_tags, name: :category_tags, blueprint: DefaultBlueprint
  association :service_area, blueprint: ServiceAreaBlueprint, view: :with_location do |contribution|
    contribution.service_areas.first
  end

  association :contact_types, blueprint: DefaultBlueprint do |contribution, _options|
    [contribution.preferred_contact_method]
  end
  association :urgency, blueprint: DefaultBlueprint do |contribution, _options|
    UrgencyLevel.find(contribution.urgency_level_id)
  end
  association :location, blueprint: LocationBlueprint
  fields :title, :description, :inexhaustible, :name
  field :created_at do |contribution, _options|
    contribution.created_at.to_f * 1000 # Javascript wants miliseconds, not seconds
  end
  field :type, name: :contribution_type

  field :view_path do |contribution, options|
    routes.contribution_path(contribution.id) if options[:show_view_path]
  end
  field :match_path do |contribution, options|
    routes.match_listing_listing_path(contribution.id) if options[:show_match_path]
  end

  class << self
    private

    def routes
      Rails.application.routes.url_helpers
    end
  end
  association :person, blueprint: PersonBlueprint
end
