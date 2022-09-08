# frozen_string_literal: true

# Application controller
class ApplicationController < ActionController::Base
  include DeviseConfigurer
  include RecordRescuable
  include Pundit::Authorization

  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_to(request.referer || root_path, notice: 'You are not authorized to perform this action.')
  end
end
