# frozen_string_literal: true

class CommunityResource < ApplicationRecord
  extend Mobility
  translates :name, type: :string
  translates :description, type: :string

  acts_as_taggable_on :tags

  belongs_to :location, optional: true, autosave: true
  belongs_to :organization, optional: true # FIXME: - should this be optional?

  has_many :matches_as_receiver
  has_many :matches_as_provider
  has_many :community_resource_service_areas
  has_many :service_areas, through: :community_resource_service_areas

  validates :name, :description, :publish_from, presence: true

  accepts_nested_attributes_for :organization

  scope :approved,       -> { where(is_approved: true) }
  scope :pending_review, -> { where(is_approved: false) }
  # TODO: add tests for this?
  scope :in_service_areas, ->(ids) { joins(:service_areas).where(service_areas: {id: ids}).distinct }

  def self.published
    before_now = DateTime.new..Time.current
    after_now  = Time.current..DateTime::Infinity.new

    approved.where(publish_from: before_now, publish_until: nil).or(
      approved.where(publish_from: before_now, publish_until: after_now)
    )
  end

  def title; description; end
  def self.matchable; published; end

  def published?
    now = Time.current
    is_approved &&
      (publish_from.present? ? publish_from <= now : true) &&
      (publish_until.nil? || now < publish_until)
  end

  def categories_for_tags
    Category.where(name: tag_list)
  end

  def all_tags_unique
    all_tags_list.flatten.map(&:downcase).uniq
  end

  def all_tags_to_s
    all_tags_unique.join(', ')
  end

  def preferred_contact_method
    # TODO: This is a hack that makes things work for now
    # The test creates a contact method that will match this
    # and the dev db seeding creates a couple, too
    ContactMethod.method_name('call').last
  end

  def type
    "Community Resource"
  end

  def inexhaustible
    true
  end

  def urgency_level_id
    UrgencyLevel::TYPES.last.id
  end

  def person; end
end

# == Schema Information
#
# Table name: community_resources
#
#  id                  :bigint           not null, primary key
#  description         :string
#  facebook_url        :string
#  is_approved         :boolean          default(TRUE), not null
#  is_created_by_admin :boolean          default(TRUE), not null
#  name                :string
#  phone               :string
#  publish_from        :date
#  publish_until       :date
#  tags                :string           default([]), is an Array
#  website_url         :string
#  youtube_identifier  :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  location_id         :bigint
#  organization_id     :bigint
#  service_area_id     :bigint
#
# Indexes
#
#  index_community_resources_on_is_approved          (is_approved)
#  index_community_resources_on_is_created_by_admin  (is_created_by_admin)
#  index_community_resources_on_location_id          (location_id)
#  index_community_resources_on_organization_id      (organization_id)
#  index_community_resources_on_service_area_id      (service_area_id)
#  index_community_resources_on_tags                 (tags) USING gin
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (service_area_id => service_areas.id)
#
