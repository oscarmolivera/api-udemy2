require 'rails_helper'

RSpec.describe "#Routing", type: :routing do
  it "should route to access_token create action in /login." do
    expect(post ("/login")).to route_to("access_tokens#create")
  end

  it "should route to access_token destroy action in /logout." do
    expect(post ("/logout")).to route_to("access_tokens#destroy")
  end
end
