# frozen_string_literal: true

# Record concern
module RecordRescuable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  end

  protected

  def handle_record_not_found
    redirect_to(request.referer || root_path, notice: 'Record Not Found')
  end
end
