class AccessTokensController < ApplicationController

  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
    
    render json: serializer.new(authericator.access_token), status: :created
  end
  
end
