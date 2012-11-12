require 'integration_helper'

def create_channel(user)
  FactoryGirl.create(:channel, created_by: user.graph_user)
end

describe "channels", type: :request do

  before :each do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  it "can be visited" do
    @channel = create_channel(@user)

    visit channel_path(@user, @channel)

    page.should have_content(@channel.title)
  end
end
