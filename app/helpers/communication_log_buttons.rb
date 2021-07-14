# frozen_string_literal: true

module CommunicationLogButtons # rubocop:todo Metrics/ModuleLength
  def remote_communication_log_button( # rubocop:todo Metrics/ParameterLists
    person,
    match: nil,
    needs_follow_up: false,
    subject: nil,
    body: nil,
    delivery_method_name: 'email',
    delivery_status: 'sent',
    button_text: 'Add Communication Log',
    icon_class: 'fa fa-plus',
    margin_class: nil,
    created_by: nil,
    path: nil,
    method: :post,
    remote: true
  )

    delivery_method = ContactMethod.where(name: delivery_method_name.titleize).first_or_create!(name: delivery_method_name.titleize, field: nil, enabled: false)

    link_path = create_remote_communication_logs_path(communication_log: {
      person_id: person&.id,
      match_id: match&.id,
      needs_follow_up: needs_follow_up,
      delivery_status: delivery_status,
      outbound: true,
      delivery_method_id: delivery_method&.id,
      subject: "[#{button_text}] #{subject}",
      body: body,
      created_by_id: created_by&.id,
      sent_at: Time.now
    })

    link_to(
      link_path,
      partial: 'form',
      title: 'New communication log',
      class: "button add-button #{margin_class} is-primary is-outlined",
      method: method,
      remote: remote
    ) do
      "<span class='#{icon_class}'></span><span style='padding-left: 0.25em'> #{button_text}</span>".html_safe
    end
  end

  def log_autoemail_button( # rubocop:todo Metrics/ParameterLists
    person,
    match: nil,
    subject: nil,
    body: nil,
    created_by: nil,
    needs_follow_up: false
  )
    remote_communication_log_button(person,
      match: match,
      needs_follow_up: needs_follow_up,
      subject: subject,
      body: body,
      delivery_method_name: 'autoemail',
      icon_class: 'fa fa-envelope',
      button_text: 'Autoemail was sent',
      created_by: created_by)
  end

  def log_email_button(person, match: nil, subject: nil, body: nil, created_by: nil)
    remote_communication_log_button(person,
      match: match,
      needs_follow_up: true,
      delivery_status: 'sent',
      subject: subject,
      body: body,
      delivery_method_name: 'email',
      icon_class: 'fa fa-envelope',
      button_text: 'Email was sent',
      created_by: created_by)
  end

  def log_text_button(person, match: nil, subject: nil, body: nil, created_by: nil)
    remote_communication_log_button(person,
      match: match,
      needs_follow_up: true,
      delivery_status: 'sent',
      subject: subject,
      body: body,
      delivery_method_name: 'text',
      icon_class: 'fa fa-comment',
      button_text: 'Text was sent',
      created_by: created_by)
  end

  def log_voicemail_button(person, match: nil, subject: nil, body: nil, created_by: nil)
    remote_communication_log_button(person,
      match: match,
      needs_follow_up: true,
      subject: subject,
      body: body,
      delivery_method_name: 'call',
      icon_class: 'fa fa-microphone-alt',
      button_text: 'Left Voicemail',
      created_by: created_by)
  end

  def log_no_connection_button(person, match: nil, subject: nil, body: nil, created_by: nil)
    remote_communication_log_button(person,
      match: match,
      needs_follow_up: true,
      subject: subject,
      body: body,
      delivery_method_name: 'phone',
      delivery_status: 'undeliverable',
      icon_class: 'fa fa-exclamation-circle',
      button_text: "Couldn't get through",
      created_by: created_by)
  end

  def log_connection_button( # rubocop:todo Metrics/ParameterLists
    person,
    match: nil,
    subject: nil,
    body: nil,
    created_by: nil,
    needs_follow_up: false
  )
    remote_communication_log_button(person,
      match: match,
      needs_follow_up: needs_follow_up,
      subject: subject,
      body: body,
      delivery_method_name: 'text',
      delivery_status: 'connected',
      icon_class: 'fa fa-check-circle',
      button_text: 'Connected with them!',
      created_by: created_by)
  end

  def new_communication_log_button( # rubocop:todo Metrics/ParameterLists
    person,
    match: nil,
    subject: nil,
    body: nil,
    created_by: nil,
    needs_follow_up: true,
    contribution: nil
  )
    delivery_method = ContactMethod.where(name: 'Text').first_or_create!(field: 'phone', enabled: false)
    link_path = new_communication_log_path(
      contribution_id: contribution&.id,
      person_id: person&.id,
      match_id: match&.id,
      created_by: created_by,
      needs_follow_up: needs_follow_up,
      outbound: true,
      delivery_method_id: delivery_method&.id,
      delivery_status: 'connected',
      subject: subject,
      body: body,
      created_by_id: created_by&.id,
      sent_at: Time.now
    )
    link_to(
      link_path,
      title: 'New communication log',
      class: 'button add-button is-primary is-outlined'
    ) do
      "<span class='fa fa-plus}'></span><span style='padding-left: 0.25em'> Add a detailed log</span>".html_safe
    end
  end
end
