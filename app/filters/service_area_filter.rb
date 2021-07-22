class ServiceAreaFilter < BaseFilter
  def self.filter_grouping
    {
      name: 'Service Areas',
      filter_options: FilterOptionBlueprint.render_as_hash(ServiceArea.i18n)
    }
  end

  def filter(scope)
    return super unless parameters
    scope.in_service_areas(parameters.keys)
  end
end
