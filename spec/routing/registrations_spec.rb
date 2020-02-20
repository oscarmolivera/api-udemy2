require 'rails_helper'

RSpec.describe RegistrationsController, type: :routing do
  describe ' routing' do
    it 'routes to #create' do
      expect(post: '/signup').to route_to('registrations#create')
    end
  end
end
