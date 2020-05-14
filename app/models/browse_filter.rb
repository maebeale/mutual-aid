# BrowseFilter code currently makes a lot of assumptions about the model coming in
# I'm going to have to some lifting to make it accept other models
# but at least all these changes will be isolated to this class
module BrowseFilter
  FILTERS = {
    'ServiceArea' => ->(ids, scope) { scope.where(service_area: ids) },
    'ContactMethod' => ->(ids, scope) { scope.joins(:person).where(people: {preferred_contact_method: ids})},
    'Category' => lambda do |ids, scope|
      scope.tagged_with(
        Category.roots.where(id: ids).pluck('name'),
        any: true
      )
    end,
    'UrgencyLevel' => lambda do |ids, scope|
      ids.length == UrgencyLevel::TYPES.length ? scope : scope.where(urgency_level_id: ids)
    end
  }.freeze

  ALLOWED_PARAMS = (['ContributionType'] + FILTERS.keys).each_with_object({}) do |key, hash|
    hash[key] = {}
  end.freeze
  ALLOWED_MODEL_NAMES = ['Ask', 'Offer'].freeze

  class << self
    def contributions_for(parameters)
      model_names = parameters.fetch('ContributionType', ALLOWED_MODEL_NAMES)
      models = ContributionType.where(name: model_names.intersection(ALLOWED_MODEL_NAMES)).map(&:model)
      models.map { |model| filter_by(parameters, model) }.flatten
    end

    def filter_by(conditions, model)
      conditions.keys.reduce(model.all) do |scope, key|
        filter = FILTERS.fetch(key, ->(_condition, s) {s})
        filter.call(conditions[key], scope)
      end
    end
  end
end
