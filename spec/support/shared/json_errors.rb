require 'rails_helper'

  shared_examples_for "forbidden_requests" do
    let(:authorization_error) do{
      "status" => "403", 
      "source" => "{'pointer' => '/headers/authorization'}", 
      "title" => "Not Authorized", 
      "details" => "No se tiene permiso para realizar la acción." 
    }
    end

    it "should responds a 403 code" do
      subject
      expect(subject).to  have_http_status(403)
    end

    it "should have proper Json object responds" do
      subject
      expect(json['error']).to eq(authorization_error)
    end
  end

  shared_examples_for "unauthorized_requests" do
    let(:error) do
      {
        "status" => "401",
        "source" => { "pointer" => "/code" },
        "title" =>  "Authentication code invalid",
        "detail" => "You must provide a valid code in order to exchange it for a token"
      }
    end

    it 'should return 401 status code' do
      subject
      expect(response).to have_http_status(401)
    end

    it 'should return proper error body' do
      subject
      expect(json['errors']).to include(error)
    end
  end