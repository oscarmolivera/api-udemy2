require 'rails_helper'

describe UserAuthenticator do
  let(:user) { create :user, login: 'user_login', password: 'user_pwd' }

  shared_examples_for 'authenticator' do
    it "should create and set user's access token" do
      expect(authenticator.authenticator).to receive(:perform).and_return(true)
      expect(authenticator.authenticator).to receive(:user).at_least(:once).and_return(user)
      expect{ authenticator.perform }.to change{ AccessToken.count }.by(1)
      expect(authenticator.access_token).to be_present
    end
  end
  context 'when is initialited with code' do
    let(:authenticator) { described_class.new(code:'sample_code') }
    let(:authenticator_class) { UserAuthenticator::Oauth }

    describe '#initialize' do
      it 'should initialize proper authenticator.' do
        expect(authenticator_class).to receive(:new).with('sample_code')
        authenticator
      end
    end
    it_behaves_like 'authenticator'
  end

  context 'when is initialized with login and password' do
    let(:authenticator) do
      described_class.new(
        login: 'user_login',
        password: 'user_pwd'
      )
    end
    let(:authenticator_class) { UserAuthenticator::Principal }

    describe '#initialize' do
      it 'should initialize proper authenticator' do
        expect(authenticator_class).to receive(:new).with(
          'user_login', 'user_pwd'
        )
        authenticator
      end
    end
    it_behaves_like 'authenticator'
  end
end
