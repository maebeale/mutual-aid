require 'rails_helper'

RSpec.describe ContributionBlueprint do
  let(:user) { build :user, :admin }
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
    expected_data = {'contributions' => [{
      'id' => contribution.id,
      'contribution_type' => 'Ask',
      'category_tags' => [{'id' => expected_category_id, 'name' => expected_category}],
      'inexhaustible' => contribution.inexhaustible,
      'urgency' => {'id' => 1, 'name' => 'Within 1-2 days'},
      # # TODO: not yet implemented:
      # "availability" => [{"id" => 1, "name" => "AM"}],
      # "publish_until" => "2021-10-11",
      # "publish_until_humanized" => "this year",
      'created_at' => (contribution.created_at.to_f * 1000), # Javascript wants miliseconds, not seconds
      'view_path' => nil,
      'match_path' => nil,
      'name' => contribution.name,
      'location' => nil,
      'person' => {
        'id' => contribution.person.id,
        'name' => contribution.person.name,
        'email' => contribution.person.email,
        'phone' => contribution.person.phone,
        'skills' => contribution.person.skills,
        'preferred_contact_method' => {
          'id' => contribution.person.preferred_contact_method.id,
          'name' => contribution.person.preferred_contact_method.name
        }
      },
      'service_area' => {
        'description' => contribution.service_area.description,
        'id' => contribution.service_area.id,
        'name' => expected_area_name,
        'location' => {
          'city' => contribution.service_area.location.city,
          'county' => contribution.service_area.location.county,
          'id' => contribution.service_area.location.id,
          'neighborhood' => contribution.service_area.location.neighborhood,
          'region' => contribution.service_area.location.region,
          'state' => contribution.service_area.location.state,
          'street_address' => contribution.service_area.location.street_address,
          'zip' => contribution.service_area.location.zip
        }
      },
      # "map_location" => "44.5,-85.1",
      'title' => contribution.title,
      'description' => contribution.description,
      'contact_types' => [{'id' => expected_contact_method.id, 'name' => expected_contact_method.name}]
    }]}
    result = ContributionBlueprint.render([contribution], root: 'contributions', current_user: user)
    expect(JSON.parse(result)).to match(expected_data)
  end

  it 'emits contribution_path as view_path if the show_view_path option is present' do
    expected_path = Rails.application.routes.url_helpers.contribution_path(contribution)
    result = ContributionBlueprint.render(contribution, show_view_path: true, current_user: user)
    expect(JSON.parse(result)['view_path']).to eq(expected_path)
  end

  it 'can serialize a community resource as a contribution' do
    resource = create(:community_resource)
    # The test database defaults to having no contact methods, so we need at least one
    default_contact_method = create(:contact_method)
    expected_result = {
      "id" => resource.id,
      "category_tags" => [],
      "contact_types" => [{"id" => default_contact_method.id, "name" => "Call"}],
      "contribution_type" => "Community Resource",
      "created_at" => resource.created_at.to_f * 1000,
      "description" => "Food for the revolution",
      "inexhaustible" => true,
      "location" => nil,
      "match_path" => nil,
      "name" => "Free breakfast for School Children Program",
      "person" => nil,
      "service_area" => nil,
      "title" => "Food for the revolution",
      "urgency" => {"id" => 4, "name" => "Anytime"},
      "view_path" => nil
    }
    result = ContributionBlueprint.render(resource, current_user: user)
    expect(JSON.parse(result)).to eq(expected_result)
  end
end
