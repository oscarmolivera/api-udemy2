class AccessTokensController < ApplicationController
  class AuthorizationError < StandardError; end

  rescue_from AuthorizationError, with: :authorization_error
  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
    render json: serializer.new(authenticator.access_token), status: :created
  end

  def destroy 
    raise AuthorizationError
  end

  private
  def serializer
    AccessTokenSerializer
  end

  def authorization_error
    error = {
      "status" => "403", 
      "source" => "{'pointer' => '/headers/authorization'}", 
      "title" => "Not Authorized", 
      "details" => "No se tiene permiso para realizar la acción." 
    }
    render json: {error: error}, status: :forbidden
  end
  
end
