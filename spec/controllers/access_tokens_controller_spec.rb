require 'rails_helper'

RSpec.describe AccessTokenController, type: :controller do

  describe "#create" do
    subject {post :create}
    let(:error) do 
      {
        "status" => "401",
        "source" => { "pointer" => "/code" },
        "title" =>  "Authentication code invalid",
        "detail" => "You must provide a valid code in order to exchange it for a token"
      }
    end
    context "when invalid request" do
      it "sholud return 404 code" do
       subject
        expect(response).to have_http_status(401)
      end

      it "should respond a proper Json Error object" do
        subject
        expect(json['errors']).to  include(error)
      end
    end

    context "when valid request" do
      
    end
  end#create
end#Rspec
