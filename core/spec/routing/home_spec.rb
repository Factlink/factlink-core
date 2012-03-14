require "spec_helper"

describe HomeController do
  describe "routing" do
    describe "tour" do
      it "should route correctly" do
        pending "this does not work because it is in the authenticated section of the routes."
        # if you change this, change the tour-modal.js as well!
        get("/p/tour").should route_to "home#tour"
      end
    end
  end
end
