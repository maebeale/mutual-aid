class CategoryFilter < BaseFilter
  def self.filter_grouping_name
    'Categories'
  end

  def self.filter_options
    Category.roots
  end

  def filter(scope)
    return super unless parameters
    scope.tagged_with(
      Category.roots.where(id: parameters.keys).pluck('name'),
      any: true
    )
  end
end
