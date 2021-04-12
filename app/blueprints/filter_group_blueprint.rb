# frozen_string_literal: true

class FilterGroupBlueprint < Blueprinter::Base
  field :filter_grouping_name, name: :name

  association :filter_options, blueprint: ->(filter_options) do
    if filter_options == ContributionTypeFilter.filter_options
      ContributionTypeFilterOptionBlueprint
    else
      FilterOptionBlueprint
    end
  end
end
