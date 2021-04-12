# frozen_string_literal: true

class ContributionTypeFilterOptionBlueprint < Blueprinter::Base
  identifier :id do |filter_option|
    "ContributionType[#{filter_option}]"
  end

  field :name do |filter_option|
    filter_option
  end
end
