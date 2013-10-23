require 'spec_helper'

describe "tos/show" do
  it "should render" do
    view.stub(:current_user) { create :user }
    render
    rendered.should have_selector('div')
  end
end
