require "spec_helper"

describe "facts/show.html.erb" do

  def authenticate_user!
    @user = FactoryGirl.create(:user)
    assign(:warden, mock(Warden, :authenticate => @user, :authenticate! => @user))
  end

  it "displays all the orders" do
    @f = FactoryGirl.create(:fact)
    @f.data.displaystring = 'foobar'
    @f.data.save
    authenticate_user!
    
    assign(:fact, @f)
    assign(:potential_evidence, [])

    render

    rendered.should =~ /foobar/
  end
end