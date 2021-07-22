class BasePresenter < SimpleDelegator
  attr_reader :h
  delegate :context, to: :h
  alias_method :object, :__getobj__

  def initialize object, view_context
    super object
    @h = view_context
  end
end
