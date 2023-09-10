require 'rails_helper'

RSpec.describe "Rounds", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/rounds/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/rounds/show"
      expect(response).to have_http_status(:success)
    end
  end

end
