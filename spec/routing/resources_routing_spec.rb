require "rails_helper"

RSpec.describe ResourcesController, type: :routing do

  xdescribe "routing" do

    it "routes to #edit" do
      expect(get: "/hosts/1/resources/1/edit").to route_to("resources#edit", id: "1", host_id: 1)
    end

    it "routes to #update" do
      expect(put: "/hosts/1/resources/1").to route_to("resources#update", id: "1", host_id: 1)
    end

    it "routes to #destroy" do
      expect(delete: "/hosts/1/resources/1").to route_to("resources#destroy", id: "1", host_id: 1)
    end

  end
end
