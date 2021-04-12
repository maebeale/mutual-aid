class ContactMethodFilter < BaseFilter
  def self.filter_grouping_name
    'Contact Methods'
  end

  def self.filter_options
    ContactMethod.enabled.distinct(:name)
  end

  def filter(scope)
    return super unless parameters
    scope.joins(:person).where(people: {preferred_contact_method: parameters.keys})
  end
end
