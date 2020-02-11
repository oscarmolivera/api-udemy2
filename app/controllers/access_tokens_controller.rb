class AccessTokensController < ApplicationController
  class AuthorizationError < StandardError; end

  skip_before_action :authorize!, only: :create
  
  rescue_from AuthorizationError, with: :authorization_error
  def create
    authenticator = UserAuthenticator.new(params[:code])
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

  
end
