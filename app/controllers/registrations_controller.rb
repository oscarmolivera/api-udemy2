# frozen_string_literal: true

# Controller for Registrations
class RegistrationsController < ApplicationController
  skip_before_action :authorize!, only: [:create]

  def create
    user = User.new(registration_params.merge(provider: 'UdemyApiApp'))
    user.save!
    render json: serializer.new(user), status: :created
  rescue ActiveRecord::RecordInvalid
    render jsonapi_errors: user.errors, status: :unprocessable_entity
  end

  private

  def registration_params
    params.require(:data)
          .require(:attributes)
          .permit(:login, :password) ||
      ActionController::Parameters.new
  end

  def serializer
    RegistrationSerializer
  end
end
