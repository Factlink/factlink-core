require 'spec_helper'

describe "facts/new" do
  it "should render" do
    @fact = Channel.new
    render
    rendered.should have_selector('div')
  end
end