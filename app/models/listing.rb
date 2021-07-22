# frozen_string_literal: true

class Listing < ApplicationRecord
  extend Mobility

  acts_as_taggable_on :tags

  translates :title, type: :string
  translates :description, type: :string

  belongs_to :person
  belongs_to :service_area
  belongs_to :location, optional: true
  belongs_to :submission, optional: true
  belongs_to :urgency_level, optional: true, class_name: 'UrgencyLevel'

  has_many :matches_as_receiver, class_name: 'Match', foreign_key: 'receiver_id'
  has_many :matches_as_provider, class_name: 'Match', foreign_key: 'provider_id'

  accepts_nested_attributes_for :location

  validates :type, presence: true

  enum state: {unmatched: 0, matched: 1}

  MATCH_STATUSES = ['matched', 'unmatched']

  scope :asks, -> { where(type: Ask.to_s) }
  scope :offers, -> { where(type: Offer.to_s) }
  scope :created_on, ->(created_on) { where('created_at::date = ?', created_on) }
  scope :inexhaustible, -> { where(inexhaustible: true) }
  scope :location_id, ->(location_id) { where(location_id: location_id.to_i) }
  scope :match_status, ->(match_status) { where(state: match_status.to_s) }
  scope :person_id, ->(person_id) { where(person_id: person_id.to_i) }

  scope :service_area_name, ->(service_area_name) {
    includes(service_area: :mobility_string_translations)
      .references(:mobility_string_translations)
      .where('mobility_string_translations.value = ?', service_area_name.to_s)
  }

  def self.all_tags_unique(collection)
    collection ||= all
    collection.map(&:all_tags_unique).flatten.uniq
  end

  def communication_logs
    person.communication_logs.where(match: self)
  end

  def matches
    ask? ? matches_as_receiver : matches_as_provider
  end

  def name
    type + ": #{all_tags_to_s}"
  end

  def name_and_match_history
    inexhaustible_str = inexhaustible ? ' ***INEXHAUSTIBLE***' : ''

    donation_amount_str =
      if person&.monthly_donation_amount_max.to_f > 0.0
        " --- $#{person.monthly_donation_amount_max}/mo left"
      else
        ''
      end

    "(#{type}-#{all_tags_to_s.upcase}#{inexhaustible_str})" \
    " #{person.match_history}. " \
    "(#{person.name}#{donation_amount_str})"
  end

  def status
    status = 'unmatched'
    if matches_as_receiver.any?
      status = matches_as_receiver.map { |m| m.completed? }.any? ? 'completed' : 'matched'
    elsif matches_as_provider.any?
      status = matches_as_provider.map { |m| m.completed? }.any? ? 'completed' : 'matched'
    end
    update(state: status)
    status
  end

  def ask?
    type == 'Ask'
  end

  def offer?
    type == 'Offer'
  end

  def icon_class
    if ask?
      'fa fa-hand-sparkles'
    elsif offer?
      'fa fa-hand-holding-heart'
    else
      'fa fa-question-circle'
    end
  end

  def all_tags_unique
    all_tags_list.flatten.map(&:downcase).uniq
  end

  def all_tags_to_s
    all_tags_unique.join(', ')
  end

  def categories_for_tags
    Category.where(name: tag_list)
  end

  def service_areas
    [service_area]
  end

  def has_email?
    person.email.present?
  end

  def preferred_contact_method
    person.preferred_contact_method
  end
end

# == Schema Information
#
# Table name: listings
#
#  id               :bigint           not null, primary key
#  description      :text
#  inexhaustible    :boolean          default(FALSE), not null
#  state            :integer          default("unmatched")
#  tags             :text             default([]), is an Array
#  title            :string
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  location_id      :bigint
#  person_id        :bigint           not null
#  service_area_id  :bigint           not null
#  submission_id    :bigint
#  urgency_level_id :bigint
#
# Indexes
#
#  index_listings_on_location_id       (location_id)
#  index_listings_on_person_id         (person_id)
#  index_listings_on_service_area_id   (service_area_id)
#  index_listings_on_submission_id     (submission_id)
#  index_listings_on_tags              (tags) USING gin
#  index_listings_on_urgency_level_id  (urgency_level_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (service_area_id => service_areas.id)
#  fk_rails_...  (submission_id => submissions.id)
#
