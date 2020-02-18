class UserAuthenticator
  class AuthenticatorError < StandardError; end

  attr_reader :authenticator

  def initialize(code: nil, login: nil, password: nil)
    @authenticator =  if code.present?
                        Oauth.new(code)
                      else
                        Principal.new(login, password)
                      end
  end

  def perform
    authenticator.perform
  end

  def user
    authenticator.user
  end

  def access_token
    authenticator.access_token
  end
end
