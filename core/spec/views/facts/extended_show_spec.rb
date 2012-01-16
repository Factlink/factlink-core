require 'spec_helper'

describe "facts/extended_show" do
  it "should have a wheel" do
    pending "Something is wrong with assigning fact to fact_bubble"
    view.stub(:user_signed_in?) { true }
    view.stub(:current_user) { create :user }

    assign(:fact, Fact.new)

    render
    rendered.should have_selector('div.wheel')
  end
end