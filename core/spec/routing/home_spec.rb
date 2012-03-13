require "spec_helper"

describe HomeController do
  describe "routing" do
    describe "tour" do
      it "should route correctly" do
        # if you change this, change the tour-modal.js as well!
        get("/p/tour").should route_to "home#tour"
      end
    end
  end
end
