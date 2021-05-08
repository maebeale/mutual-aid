require 'rails_helper'

RSpec.describe 'Registration', type: :system do
  before do
    create(:organization, is_host: true)
  end

  it 'is able to load the landing page' do
    visit '/'
    expect(page.title).to eq 'Mutual-aid'
  end
end
