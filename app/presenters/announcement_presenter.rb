class AnnouncementPresenter < BasePresenter
  def expires_on
    return "This announcement does not expire." unless publish_until

    expire_text = publish_until > Time.current ? "Expires" : "Expired"
    "#{expire_text} on #{I18n.l(publish_until, format: :long_month)}"
  end
end
