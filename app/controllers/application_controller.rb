class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pagy::Backend

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[fname lname image image_cache])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[fname lname image image_cache])
  end
end
