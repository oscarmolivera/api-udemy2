require 'rails_helper'

describe UserAuthenticator do
  context 'when is initialited with code' do
    let(:authenticator) { described_class.new(code:'sample_code') }
    let(:authenticator_class) { UserAuthenticator::Oauth }

    describe '#initialize' do
      it 'should initialize proper authenticator.' do
        expect(authenticator_class).to receive(:new).with('sample_code')
        authenticator
      end
    end
  end

  context 'when is initialized with password' do
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
  end
end
