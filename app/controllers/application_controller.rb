# frozen_string_literal: true

# Application controller
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def routing_error(_error = 'Routing error', _status = :not_found, _exception = nil)
    render file: 'public/404.html', status: :not_found, layout: false
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password username])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email password username image bio account])
  end

  def record_not_found
    redirect_to(request.referer || root_path, notice: 'Record Not Found')
  end
end
