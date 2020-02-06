require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#validations" do
    
    it "should validates precence of factory" do
      user = build :user
      expect(user).to  be_valid
    end

    it "should validate precence of login" do
      user = build :user, login: nil
      expect(user).not_to  be_valid()
      expect(user.errors.messages[:login]).to include("can't be blank")
    end

    it "should validate precence of provider" do
      user = build :user, provider: nil
      expect(user).not_to  be_valid()
      expect(user.errors.messages[:provider]).to include("can't be blank")
    end

    it "should validate login uniqness" do
      user_1 = create :user
      user_2 = build :user, login: user_1.login
      expect(user_2).not_to  be_valid()
    end
  end
  
end
