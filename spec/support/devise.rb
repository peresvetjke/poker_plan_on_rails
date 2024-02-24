# frozen_string_literal: true

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :feature
  # config.include Warden::Test::Helpers
end
