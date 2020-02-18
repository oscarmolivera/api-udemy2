class UserAuthenticator::Oauth < UserAuthenticator
  class AuthenticatorError < StandardError; end

  attr_reader :user, :access_token

  def initialize(code)
    @code = code
  end

  def perform
    raise AuthenticatorError if code.blank?
    raise AuthenticatorError if token.try(:error).present?
     prepare_user
     @access_token = if user.access_token.present? 
      user.access_token
     else
      user.create_access_token
     end
  end

  private

  attr_reader :code

  def client
    @client ||= Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
  end

  def token
    @token ||= client.exchange_code_for_token(code)
  end

  def user_data
    @user_data ||= Octokit::Client.new(access_token: token)
                                  .user.to_h
                                  .slice(:login, :name, :url, :avatar_url)
                                  .merge(provider: 'GITHUB')
  end

  def prepare_user
    User.exists?(login: user_data[:login])
    @user = if User.exists?(login: user_data[:login])
      User.find_by(login: user_data[:login])
    else 
      User.create(user_data)
    end
  end
end