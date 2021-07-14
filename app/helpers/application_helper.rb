# frozen_string_literal: true

module ApplicationHelper
  require "#{Rails.root}/app/helpers/index_action_buttons.rb"
  require "#{Rails.root}/app/helpers/communication_log_buttons.rb"

  include CommunicationLogButtons
  include IndexActionButtons

  def yes_no(boolean)
    "<span class='#{boolean ? "fa fa-check-circle has-text-success" : "fa fa-ban"}'></span>".html_safe
  end

  def edit_button( # rubocop:todo Metrics/ParameterLists, Metrics/CyclomaticComplexity, Metrics/MethodLength
    resource, button_text = 'Edit', icon_class = 'fa fa-edit',
    button_text_class = nil, button_class = nil, params = {}, button_title = nil, path = nil
  )
    if resource
      resource_class = resource.class
      if resource_class.superclass != ApplicationRecord
        resource = resource.becomes(resource.class.superclass)
      end
      link_to(
        path.present? ? "#{path}?#{params}" : edit_polymorphic_path(resource, params),
        title: button_title || (action_name || button_text + ' ' + controller_path || resource_class.to_s),
        class: "button edit-button #{button_class}"
      ) do
        "<span class='#{icon_class || resource_class::ICON}'></span><span class='#{button_text_class}' style='padding-left: 0.25em'> #{button_text}</span>".html_safe
      end
    end
  end

  def show_button( # rubocop:todo Metrics/ParameterLists
    resource,
    button_text = 'View',
    icon_class = 'fa fa-eye',
    margin_class = nil,
    button_text_class = nil,
    params = {}
  )
    resource_class = resource.class
    if resource_class != Person && (resource_class.superclass != ApplicationRecord)
      resource = resource.becomes(resource.class.superclass)
    end
    link_to(
      polymorphic_path(resource, params),
      title: action_name || button_text + ' ' + controller_path || resource_class.to_s,
      class: "button show-button #{margin_class}"
    ) do
      "<span class='#{icon_class}'></span><span class='#{button_text_class}' style='padding-left: 0.25em'> #{button_text}</span>".html_safe
    end
  end

  def triage_button(resource, button_color_class = nil)
    resource_class = resource.class
    if resource_class != Person && (resource_class.superclass != ApplicationRecord)
      resource = resource.becomes(resource.class.superclass)
    end
    link_to(
      edit_contribution_path(resource),
      title: 'Triage',
      class: "button triage-button #{button_color_class || 'is-primary'}"
    ) do
      "<span class='fa fa-edit'></span><span style='padding-left: 0.25em'> Triage</span>".html_safe
    end
  end

  def shorthand_display(date_or_datetime) # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    # if date is in the future OR not earlier than 7 days ago, show long version
    today = Time.zone.today
    strftime = if date_or_datetime.to_date == today
      'Today'
    elsif date_or_datetime.to_date == (today - 1.day)
      'Yesterday'
    elsif (date_or_datetime.to_date >= today + 1.day) || !(date_or_datetime.to_date > (today - 7.days))
      '%a, %b %d, %Y'
    else
      '%a'
    end
    date_or_datetime.strftime("#{strftime}#{' @ %l:%M %P' if date_or_datetime.is_a?(DateTime)}")
  end

  def urgency_level_display(urgency_level_text)
    if urgency_level_text.include?('1-2')
      "<span class='tag is-warning is-light'>
        <span class='fa fa-is-exclamation-triangle'></span>
        <span>#{urgency_level_text}</span></span>".html_safe
    else
      urgency_level_text
    end
  end

  def site_logo_url
    # There should always be a current org, but being defensive here helps simplify tests
    context.host_organization&.logo_url.presence || asset_pack_path('media/images/logo.png')
  end
end
