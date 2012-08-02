require "spec_helper"

describe JsLibController do
  describe "routing" do

    it "routes to #redir" do
      get("/jslib/foo/bar.js").should route_to('js_lib#redir', path: 'foo/bar.js')
    end

  end
end
