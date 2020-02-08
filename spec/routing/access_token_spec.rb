require 'rails_helper'

RSpec.describe "#Routing", type: :routing do
  it "should route to access_token create action." do
    expect(post ("/login")).to route_to("access_token#create")
  end
end
