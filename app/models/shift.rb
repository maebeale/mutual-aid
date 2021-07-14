# frozen_string_literal: true

class Shift < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :team

  has_many :shift_matches
  has_many :matches, through: :shift_matches

  scope :active, -> { where('started_at >= ?', Time.now) }
  scope :today, -> { where('started_at::date = ?', Time.zone.today.strftime('%Y-%m-%d')) }

  def name
    "#{team&.name}: #{times} #{"(" + person.name + ")" if person_id}"
  end

  def times # rubocop:todo Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize
    hide_starting_p = started_at&.strftime('%p') == ended_at&.strftime('%p')
    "#{started_at&.strftime("%a at %l:%M")} #{started_at&.strftime("%P") unless hide_starting_p} - #{ended_at&.strftime("%l:%M %P") || ("TBD" if started_at.present?)}#{started_at&.strftime(", %B %d %Y")}"
  end
end

# == Schema Information
#
# Table name: shifts
#
#  id         :bigint           not null, primary key
#  ended_at   :datetime
#  notes      :text
#  started_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint           not null
#  team_id    :bigint           not null
#
# Indexes
#
#  index_shifts_on_person_id  (person_id)
#  index_shifts_on_team_id    (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (team_id => teams.id)
#
