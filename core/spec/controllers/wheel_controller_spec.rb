require 'spec_helper'

describe WheelController do
  render_views

  it "should be succesful" do
    get :show, :percentages => '15-15-70', :format => :png
    response.should be_redirect
  end

end
