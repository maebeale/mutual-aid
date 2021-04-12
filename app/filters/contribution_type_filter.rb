class ContributionTypeFilter < BaseFilter
  def self.filter_grouping_name
    'Contribution Types'
  end

  def self.filter_options
    ALL_ALLOWED_TYPES
  end

  ALL_ALLOWED_TYPES = ['Ask', 'Offer'].freeze

  def filter(scope)
    raise NotImplementedError.new(
      # So far the best solution I've found for filtering scopes by contribution types would require
      # using SQL UNIONs, which have no good support in Rails
      "Can't filter an existing scope by contribution type. Use the `ContributionTypeFilter#scopes` method generate scopes for other filters"
    )
  end

  def scopes
    classes = parameters.blank? ? ALL_ALLOWED_TYPES : parameters.keys
    classes.intersection(ALL_ALLOWED_TYPES).map do |type|
      type.constantize.matchable
    end
  end
end
