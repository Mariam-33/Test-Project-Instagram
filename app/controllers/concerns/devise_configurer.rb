# frozen_string_literal: true

# Devise concern
module DeviseConfigurer
  extend ActiveSupport::Concern
  included do
    before_action :configure_permitted_parameters, if: :devise_controller?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password username])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email password username image bio account])
  end
end
