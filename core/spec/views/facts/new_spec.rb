require 'spec_helper'

describe "facts/new" do
  it "should render" do
    view.stub(:user_signed_in?) { true }
    @fact = Fact.new
    render
    rendered.should have_selector('div')
  end
end