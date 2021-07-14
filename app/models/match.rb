# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :receiver, polymorphic: true, inverse_of: :matches_as_receiver
  belongs_to :provider, polymorphic: true, inverse_of: :matches_as_provider
  belongs_to :shift, optional: true

  has_many :communication_logs
  has_many :feedbacks
  has_many :shift_matches

  ICON = 'fa fa-handshake'
  INITIATORS = ['receiver', 'provider']
  STATUSES = ['matched_tentatively', 'match_confirmed', 'match_completed', 'provider_gave_feedback', 'receiver_gave_feedback']

  # belongs_to :coordinator, optional: true #, class_name: "Position" # TODO
  #

  scope :id, ->(id) { where(id: id) }
  scope :match_ids, ->(match_ids) { where('matches.id::text = ANY (ARRAY[?])', match_ids) }
  scope :needs_follow_up, -> { joins(:communication_logs).where('communication_logs.needs_follow_up = ?', true) }
  scope :status, ->(status) { where(status == 'all' || !status.present? ? 'matches.id IS NOT NULL' : "matches.status = '#{status.downcase}'") }

  scope :this_month, -> {
    where(
      'matches.created_at >= ? AND matches.created_at <= ?',
      Time.zone.now.beginning_of_month,
      Time.zone.now.end_of_month
    )
  }

  def self.connected_to_person_id(person)
    communication_match_ids = []
    shift_match_ids = []
    if person
      communication_match_ids = CommunicationLog.where(person: person).pluck(:match_id)
      shift_match_ids = ShiftMatch.includes(:shift).references(:shift).where('shifts.person_id = ?', person.id).pluck(:match_id)
    end
    where(id: communication_match_ids + shift_match_ids)
  end

  def self.follow_up_status(follow_up_status)
    needs_follow_up = self.needs_follow_up
    if YAML.load(follow_up_status) == false
      where.not(id: needs_follow_up)
    else
      needs_follow_up
    end
  end

  def category
    receiver.all_tags_to_s
  end

  def name
    "#{"[#{status}] "}#{receiver.name} & #{provider.name} (#{created_at.strftime("%m-%d-%Y")})"
  end

  def needs_follow_up?
    communication_logs.needs_follow_up.any?
  end

  # TODO: move this to presenter
  def person_names # rubocop:todo Metrics/AbcSize
    receiver_name = [Listing, Ask, Offer].include?(receiver.class) ? receiver.person&.name : receiver.name if receiver
    provider_name = [Listing, Ask, Offer].include?(provider.class) ? provider.person&.name : provider.name if provider
    "#{receiver_name} -and- #{provider_name}" # TODO: need to adjust for community resource
  end

  def short_name
    "#{"[#{status}] "}#{person_names}"
  end

  def full_name
    "Connected on #{created_at.strftime('%m-%-d-%Y')}: #{name} #{receiver.all_tags_to_s}"
  end
end

# == Schema Information
#
# Table name: matches
#
#  id            :bigint           not null, primary key
#  completed     :boolean          default(FALSE), not null
#  exchanged_at  :datetime
#  notes         :string
#  provider_type :string
#  receiver_type :string
#  status        :string
#  tentative     :boolean          default(TRUE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  provider_id   :integer
#  receiver_id   :integer
#
