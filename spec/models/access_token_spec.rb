require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  let(:user) {create :user, id: 1}
  describe "#validations" do
    let(:access_token) {create :access_token, user_id: user.id}

    it "should have a valid factory" do
      expect(access_token).to be_valid
    end

    it "should have a valid token" do
      access_token.token = ""
      expect(access_token).not_to be_valid
    end

    it "should be a unique token" do
      user2 = create :user, id: 2
      access_token2 = build :access_token, token: access_token.token, user_id: user2.id
      expect(access_token2).not_to be_valid
      expect(access_token2.errors.messages[:token]).to include("has already been taken")
    end
  end
  
  describe "#new" do
    
    it "should have a token present after initialization" do
      expect(AccessToken.new.token).to  be_present
    end

    it "should generate a unique token" do
      user = create :user
      expect{user.create_access_token}.to change{AccessToken.count()}.by(1)
      expect(user.build_access_token).to  be_valid
    end

    it "should create the token only once" do
      expect{ user.create_access_token }.to change{ AccessToken.count }.by(1)
      expect(user.build_access_token).to be_valid
    end
  end
  
end
