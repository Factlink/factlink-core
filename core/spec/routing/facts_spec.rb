require "spec_helper"

describe FactsController do
  describe "routing" do

    describe "intermediate" do
      it "routes to #intermediate" do
        get("/factlink/intermediate").should route_to("client#intermediate")
      end
    end

  end
end
