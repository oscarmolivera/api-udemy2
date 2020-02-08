require 'rails_helper'

RSpec.describe UserAuthenticator do
  describe "#perform" do
    let(:authenticator) {described_class.new("sample-code")}
    subject{ authenticator.perform }

    context "when the code is incorrect" do
      let(:error) {double("Sawyer::Resouce", error: "bad_verification_code")}
      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(error)
      end
      it "should show an error message" do
        expect{subject}.to  raise_error(UserAuthenticator::AuthenticatorError)
      end
    end#context

    context "when the code is correct" do
      let(:user_data) do
        {
          login: "usuario.prueba1", 
          name: "Usuario de Prueba", 
          url: "http://example-url.com",
          avatar_url: "http://gravitar.com/oolivera"
        }
      end
      
      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return('valid_token')
      end
      
      before do
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end
      
      it "should save the user when it does not exists" do
        expect{subject}.to  change{User.count}.by(1)
        expect(User.last.name).to  eq(user_data[:name])
      end

      it "should reuse already registed user" do
        user = create :user
        expect{subject}.not_to change{User.count}
        expect(authenticator.user).to  eq(user)
      end

      it "should create and set user's access token" do
        expect{subject}.to change{AccessToken.count}.by(1)
        expect(authenticator.access_token).to  be_present
      end
    end#context

  end#perform
end#RSpec