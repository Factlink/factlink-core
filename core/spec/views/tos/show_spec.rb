require 'spec_helper'

describe "tos/show" do
  it "should render" do
    view.stub(:current_user) { FactoryGirl.create :user, agrees_tos: false }
    render
    rendered.should have_selector('div')
  end
end