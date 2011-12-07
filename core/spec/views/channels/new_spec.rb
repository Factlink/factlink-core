require 'spec_helper'

describe "channels/new" do

  def params(paramshash={})
    view.should_receive(:params).any_number_of_times.and_return(paramshash)
  end
  
  it "should render" do
    assign(:channel, Channel.new)
    params({username: 'tomdev'})
    render
    rendered.should have_selector('div')
  end
end