require 'rails_helper'

describe UserAuthenticator::Principal do 
  describe '#perform' do
    let(:authenticator) { described_class.new('user_login', 'password') }
    subject { authenticator.perform }

    shared_examples_for 'invalid authentication' do
      before {user}
      it 'should raise an error' do
        expect{ subject }.to raise_error(
          UserAuthenticator::Principal::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end
    end

    context 'when invalid login' do
      let(:user) { create :user, login: 'john doe', password: '' }
      it_behaves_like 'invalid authentication'
    end

    context 'when invalid password' do
      let(:user) { create :user, login: 'user_login', password: 'not_this' }
      it_behaves_like 'invalid authentication'
    end

    context 'when no pass' do
      
    end

  end
end