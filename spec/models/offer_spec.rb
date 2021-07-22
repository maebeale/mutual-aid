require 'rails_helper'

RSpec.describe Offer do
  describe 'matched' do
    it 'returns matched offers' do
      unmatched_offer = create(:offer)
      match = create(:match, :with_ask_and_offer)
      matched_offer = match.provider

      expect(Offer.matched).to include matched_offer
      expect(Offer.matched).to_not include unmatched_offer
    end
  end

  describe 'matchable' do
    it 'returns matchable offers' do
      unmatched_offer = create(:offer)
      match = create(:match, :with_ask_and_offer)
      matched_offer = match.provider

      expect(Offer.matchable).to include unmatched_offer
      expect(Offer.matchable).to_not include matched_offer
    end
  end

  describe 'create' do 
    it 'sets an offer inexhaustable if there is a system setting for it' do
      SystemSetting.any_instance.should_receive(:inexhaustable_by_default?).returns(true)

      offer = Offer.create!
      
      expect(offer.inexhaustable).to eq(true)
    end
  end

end
