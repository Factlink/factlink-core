require "spec_helper"

describe FactsController do
  describe "routing" do

    # If you change this route, be sure to also change the
    # frame_options_headers.rb file inside the lib folder
    it "routes to #index" do
      get("/factlink/intermediate").should route_to("facts#intermediate")
    end

  end
end
