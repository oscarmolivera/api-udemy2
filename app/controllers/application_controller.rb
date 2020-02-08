class ApplicationController < ActionController::API

  rescue_from UserAuthenticator::AuthenticatorError, with: :authentication_error

  private
    def authentication_error
      error = {
        "status" => "401",
        "source" => { "pointer" => "/code" },
        "title" =>  "Authentication code invalid",
        "detail" => "You must provide a valid code in order to exchange it for a token"
      }
      render json: {"errors":[error]}, status: 401
    end

end
