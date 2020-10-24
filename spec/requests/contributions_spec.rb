require 'rails_helper'

RSpec.describe '/contributions', type: :request do
  let(:valid_attributes) { 
    {
      location_attributes: { zip: '12345' },
      tag_list: ['', 'cash']
      # name: Faker::Name.name,
      # email: Faker::Internet.email,
      # phone: Faker::PhoneNumber.phone_number
    }
  }  

  let(:invalid_attributes) { 
    {
      location_attributes: { zip: '12e45' }
    }
  }  

  before { sign_in create(:user) }

  describe 'GET /index' do
    it 'renders a successful response' do
      create(:listing)
      get contributions_url
      expect(response).to be_successful
    end

    it 'allows asking for a specific subtype of listing' do
      ask = create(:ask, title: 'this is the ask title')
      offer = create(:offer, title: 'this is the offer title')
      get contributions_url, params: { ContributionType: { 'Ask' => 1 } }
      expect(response.body).to match(ask.title)
      expect(response.body).not_to match(offer.title)
      get contributions_url, params: { ContributionType: { 'Offer' => 1 } }
      expect(response.body).not_to match(ask.title)
      expect(response.body).to match(offer.title)
      get contributions_url, params: { ContributionType: { 'Ask' => 1, 'Offer' => 1 } }
      expect(response.body).to match(ask.title)
      expect(response.body).to match(offer.title)
    end

    it 'parses requests for a filtered list' do
      categories = [
        create(:category, name: Faker::Lorem.word),
        create(:category, name: Faker::Lorem.word)
      ]
      both_tags_listing = create(:listing, tag_list: categories.map(&:name))
      expected_area = both_tags_listing.service_area
      expected_area.name = Faker::Address.community
      expected_area.save!
      one_tag_listing = create(:listing, service_area: expected_area, tag_list: categories.sample.name)
      both_tags_wrong_area_listing = create(:listing, tag_list: categories.map(&:name))
      no_tags_correct_area_listing = create(:listing, service_area: expected_area)

      # passing `as: json` to `get` does some surprising things to the request and its params that would break this test
      get contributions_url, {
        params: { "Category[#{categories[0].id}]": 1, "Category[#{categories[1].id}]": 1, "ServiceArea[#{expected_area.id}]": 1 },
        headers: { 'HTTP_ACCEPT' => 'application/json' }
      }

      expect(response.body).to match(/#{expected_area.name.to_json}/)

      response_ids = JSON.parse(response.body).map { |hash| hash['id'] }
      expect(response_ids).to include(both_tags_listing.id)
      expect(response_ids).to include(one_tag_listing.id)
      expect(response_ids).not_to include(both_tags_wrong_area_listing.id)
      expect(response_ids).not_to include(no_tags_correct_area_listing.id)
    end
  end

  describe 'GET /contributions/:id' do
    it 'is successful' do
      contribution = create(:listing)

      get(
        contribution_url(contribution)
      )

      expect(response).to be_successful
    end
  end
end
