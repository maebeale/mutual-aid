# frozen_string_literal: true

# BrowseFilter lets the browse page filter contributions by parameters, delegating much of the actual filtering
# to the classes listed in BrowseFilter::FILTER_CLASSES
class BrowseFilter
  FILTERS = {
    'Category' => CategoryFilter,
    'ServiceArea' => ServiceAreaFilter,
    'ContactMethod' => ContactMethodFilter,
    'ContributionType' => ContributionTypeFilter
    # 'UrgencyLevel' => UrgencyLevelFilter
  }.freeze
  FILTER_CLASSES = FILTERS.values.freeze
  ALLOWED_PARAMS = FILTERS.keys.each_with_object({}) { |key, hash|
    hash[key] = {}
  }.freeze

  attr_reader :parameters

  def self.filter_groupings_json
    FilterGroupBlueprint.render(FILTER_CLASSES)
  end

  def initialize(parameters)
    @parameters = parameters
  end

  # Return a filtered array of contributions
  def contributions
    # ContributionTypeFilter is special and needs to come first because of Single Table Inheretence
    # Currently, the only other option seemed to be pulling in a gem that supports UNION queries in SQL
    starting_relations = ContributionTypeFilter.new(parameters['ContributionType']).scopes

    # So using whatever relations ContributionTypeFilter gives us (unmatched asks, unmatched offers, etc.)
    @contributions ||= FILTERS.reduce(starting_relations) { |resulting_relations, (filter_name, klass)|
      # Skip ContributionTypeFilter because we've already used it
      next resulting_relations if klass == ContributionTypeFilter

      # then filter the relations further based on the rules in each class for doing so
      resulting_relations.map do |scope|
        klass.new(parameters[filter_name]).filter(scope)
      end
    }.flatten
  end
end
