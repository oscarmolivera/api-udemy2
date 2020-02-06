require 'rails_helper'

RSpec.describe "#Routing", type: :routing do
  it "should route to Articles Index." do
    expect(get("/articles")).to route_to("articles#index")
  end

  it "should route to Articles Show." do
    #expect(get("/articles/1")).to route_to("articles#show", id: 1)
    expect(get("/articles/1")).to route_to(controller: 'articles', action: 'show', id: '1')
  end
end
