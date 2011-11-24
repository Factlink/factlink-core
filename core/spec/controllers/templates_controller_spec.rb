require 'spec_helper'

describe TemplatesController do
  include Devise::TestHelpers
  include ControllerMethods
  render_views

  it "should be routed to for valid templates" do
    {get: "/templates/_channel_li"}.should route_to controller: 'templates', action: 'show', name: '_channel_li'
  end

  it "should not be routed with directory traversal" do
    {get: "/templates/../../../../etc/passwd"}.should_not be_routable
  end
  
  it "should be able to retrieve a valid template" do
    get :show, name: '_channel_li'
    response.should be_succes
  end

end
