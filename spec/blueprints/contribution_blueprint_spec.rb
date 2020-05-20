require 'rails_helper'

RSpec.describe ContributionBlueprint do
  let(:expected_category) { Faker::Lorem.word }
  let(:expected_category_id) { create(:category, name: expected_category).id }
  let(:contribution) do
    create(
        :ask,
        tag_list: [expected_category],
        title: Faker::Lorem.word,
        description: Faker::Lorem.sentence,
        urgency_level_id: 1
    )
  end
  let(:expected_contact_method) { contribution.person.preferred_contact_method }
  it 'returns reasonable data by default' do
    expected_area_name = Faker::Address.community
    contribution.service_area.name = expected_area_name
    contribution.service_area.save!
    expected_data = { "contributions" =>
                          [{
                               "id" => contribution.id,
                               "contribution_type" => "Ask",
                               "category_tags" => [{"id" => expected_category_id, "name" => expected_category}],
                               "urgency" => {"id" => 1, "name" => "Within 1-2 days"},
                               # # TODO: not yet implemented:
                               # "availability" => [{"id" => 1, "name" => "AM"}],
                               # "publish_until" => "2021-10-11",
                               # "publish_until_humanized" => "this year",
                               "created_at" => contribution.created_at.to_formatted_s(:iso8601),
                               'respond_path' => nil,
                               'profile_path' => nil,
                               "service_area" => {"id" => contribution.service_area.id, "name" => expected_area_name},
                               # "map_location" => "44.5,-85.1",
                               "title" => contribution.title,
                               "description" => contribution.description,
                               "contact_types" => [{"id" => expected_contact_method.id, "name" => expected_contact_method.name}]
                           }]
    }
    result = ContributionBlueprint.render([contribution], root: 'contributions')
    expect(JSON.parse(result)).to match(expected_data)
  end

  it 'allows injecting a url formatter for the respond_path' do
    expected_path = "/testing_#{contribution.id}"
    result = ContributionBlueprint.render(contribution, respond_path: ->(p_id) { "/testing_#{p_id}"})
    expect(JSON.parse(result)['respond_path']).to eq(expected_path)
  end

  it 'allows injecting a url formatter for the profile_path' do
    expected_path = "/testing_#{contribution.person.id}"
    result = ContributionBlueprint.render(contribution, profile_path: ->(p_id) { "/testing_#{p_id}"})
    expect(JSON.parse(result)['profile_path']).to eq(expected_path)
  end
end
