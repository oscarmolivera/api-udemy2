class ApplicationController < ActionController::API
  class AuthorizationError < StandardError; end

  rescue_from UserAuthenticator::Oauth::AuthenticatorError, with: :authentication_oauth_error
  rescue_from UserAuthenticator::Principal::AuthenticationError, with: :authentication_principal_error
  rescue_from AuthorizationError, with: :authorization_error

  before_action :authorize!

  private

  def authorize!
    raise AuthorizationError unless current_user
  end

  def access_token
    provided_token = request.authorization&.gsub(/\ABearer\s/, '')
    @access_token = AccessToken.find_by(token: provided_token)
  end

  def current_user
    @current_user = access_token&.user
  end

  def authentication_principal_error
    error =
      {
        'status' => '401',
        'source' => { 'pointer' => '/data/attributes/password' },
        'title' => 'Invalid login or password',
        'detail' =>
        'You must provide valid credentials in order to exchange it for token.'
      }
    render json: { errors: error }, status: 401
  end

  def authentication_oauth_error
    error =
      {
        'status' => '401',
        'source' => { 'pointer' => '/code' },
        'title' => 'Autentication code is invalid',
        'detail' =>
        'You must provide a valid code in order to exchange it for a token.'
      }
    render json: { errors: error }, status: 401
  end

  def authorization_error
    error =
      {
        'status' => '403',
        'source' => "{'pointer' => '/headers/authorization'}",
        'title' => 'Not Authorized',
        'details' => 'No se tiene permiso para realizar la acción.'
      }
    render json: { errors: error }, status: :forbidden
  end
end
