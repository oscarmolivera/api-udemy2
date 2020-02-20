require 'rails_helper'

shared_examples_for 'unauthorized_principal_requests' do
  let(:authentication_error) do
    {
      'status' => '401',
      'source' => { 'pointer' => '/data/attributes/password' },
      'title' => 'Invalid login or password',
      'detail' =>
        'You must provide valid credentials in order to exchange it for token.'
    }
  end

  it 'should return 401 status code' do
    subject
    expect(response).to have_http_status(401)
  end

  it 'should return proper error body' do
    subject
    expect(json['errors']).to include(authentication_error)
  end
end

shared_examples_for 'unauthorized_oauth_requests' do
  let(:authentication_error) do
    {
      'status' => '401',
      'source' => { 'pointer' => '/code' },
      'title' => 'Autentication code is invalid',
      'detail' =>
      'You must provide a valid code in order to exchange it for a token.'
    }
  end

  it 'should return 401 status code' do
    subject
    expect(response).to have_http_status(401)
  end

  it 'should return proper error body' do
    subject
    expect(json['errors']).to include(authentication_error)
  end
end

shared_examples_for 'forbidden_requests' do
  let(:authorization_error) do
    {
      'status' => '403',
      'source' => "{'pointer' => '/headers/authorization'}",
      'title' => 'Not Authorized',
      'details' => 'No se tiene permiso para realizar la acción.'
    }
  end

  it 'should return 403 status code' do
    subject
    expect(response).to have_http_status(:forbidden)
  end

  it 'should return proper error json' do
    subject
    expect(json['errors']).to include(authorization_error)
  end
end
