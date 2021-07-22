require 'rails_helper'

RSpec.describe "/users", type: :request do
  before { sign_in FactoryBot.create(:user, :sys_admin) }

  describe "GET /index" do
    it "can render" do
      get '/users'
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    let(:user) { FactoryBot.create(:user) }

    it "can render" do
      get "/users/#{user.id}"
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "can render" do
      get "/users/new"
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    let(:user) { FactoryBot.create(:user) }

    it "can render" do
      get "/users/#{user.id}/edit"
      expect(response).to be_successful
    end

    it "must redirect to the sign in page if the user is not authenticated" do
      sign_out :user
      get "/users/1/edit"
      expect(response).not_to be_successful
      expect(response.response_code).to eq(302) # Redirection
      expect(response.header["Location"]).to eq('http://www.example.com/users/sign_in')
    end
  end

  describe "POST /create" do
    it "creates the user" do
      skip "To be implemented when we have a #create action."

      expect {
        post "/users", params: {user: FactoryBot.attributes_for(:user)}
      }.to change {
        User.count
      }.by(1)
    end
  end

  describe "PATCH /update" do
    let(:user) { FactoryBot.create(:user, role: "unset") }

    it "updates the user" do
      patch "/users/#{user.id}", params: {user: {email: "atorvingen@example.com"}}

      # Manually confirming because it's required by Devise when changing a user's email address
      user.reload.confirm
      expect(user.email).to eq("atorvingen@example.com")
    end

    context "when changing roles" do
      it "allows admins to change a user's role" do
        patch "/users/#{user.id}", params: {user: {role: "neighbor"}}

        expect(user.reload.role).to eq("neighbor")
      end
    end
  end

  describe "DELETE /destroy" do
    # we need to eager-create the user so that the user is created
    # before the `User.count` block.
    let!(:user) { FactoryBot.create(:user) }

    it "deletes the user" do
      expect {
        delete "/users/#{user.id}"
      }.to change {
        User.count
      }.by(-1)
    end
  end
end
