require "spec_helper"

describe FactsController do
  describe "routing" do

    describe "intermediate" do
      # If you change this route, be sure to also change the
      # frame_options_headers.rb file inside the lib folder
      it "routes to #intermediate" do
        get("/factlink/intermediate").should route_to("facts#intermediate")
      end
    end

  end
end
