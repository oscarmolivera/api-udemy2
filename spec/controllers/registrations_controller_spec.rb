require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe 'POST #create' do
    subject { post :create, params: params }
    context 'when invalid data provided' do
      let(:params) do
        {
          data: {
            attributes: {
              login: nil,
              password: nil
            }
          }
        }
      end

      it 'should not create an user' do
        expect{ subject }.not_to change{User.count}
      end

      it 'should return code 422' do
        subject
        expect(response).to  have_http_status(422)
      end 

      it 'should return error messages in response body' do
        subject
        expect(json['errors']).to include(
          {
            'code' => 'blank',
            'detail' => "Login can't be blank",
            'source' => { 'pointer' => '/data/attributes/login' },
            'status' => '422',
            'title' => 'Unprocessable Entity'
          },
          {
            'code' => 'blank',
            'detail' => "Password can't be blank",
            'source' => { 'pointer' => '' },
            'status' => '422',
            'title' => 'Unprocessable Entity'
          }
        )
      end
    end

    context 'when valid data provided' do
      let(:params) do
        {
          data: {
            attributes: {
              login: 'jsmith',
              password: 'secret'
            }
          }
        }
      end
      it 'should return HTTP code 201' do
        subject
        expect(subject).to  have_http_status(201)
      end

      it 'should create a user' do
        expect(User.exists?(login: 'jsmith')).to be_falsey
        expect { subject }.to change { User.count }.by(1)
        expect(User.exists?(login: 'jsmith')).to be_truthy
      end
    end
  end
end
