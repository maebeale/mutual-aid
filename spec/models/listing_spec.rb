require 'rails_helper'

RSpec.describe Listing, type: :model do
  let(:listing) { build(:offer, person: create(:person)) }

  describe 'tagging' do
    example 'smoke test' do
      listing.tag_list.add('grocery shopping', 'childcare')
      listing.tag_list.add('cash')
      listing.save!

      expect(Listing.tagged_with('cash')).to match_array([listing])
    end
  end

end
