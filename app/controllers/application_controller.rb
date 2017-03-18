# frozen_string_literal: true
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActiveRecord::RecordNotFound, with: :response_for_record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :response_for_unprocessable_entity

  def response_for_record_not_found
    render json: { messages: [I18n.t(:not_found)] }, status: :not_found
  end

  def response_for_unprocessable_entity(message)
    render json: { messages: [message] }, status: :unprocessable_entity
  end
end
