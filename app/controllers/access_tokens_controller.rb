class AccessTokensController < ApplicationController
  class AuthorizationError < StandardError; end

  skip_before_action :authorize!, only: :create

  rescue_from AuthorizationError, with: :authorization_error

  def create
    authenticator = UserAuthenticator.new(authentication_params)
    authenticator.perform
    render json: serializer.new(authenticator.access_token), status: :created
  end

  def destroy
    current_user.access_token.destroy
  end

  private

  def serializer
    AccessTokenSerializer
  end

  def authentication_params
    (principal_params || params.permit(:code)).to_h.symbolize_keys
  end

  def principal_params
    params.dig(:data, :attributes)&.permit(:login, :password)
  end
end
