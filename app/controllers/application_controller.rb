# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username is_moderator])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username is_moderator])
  end
end
