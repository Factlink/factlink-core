require 'acceptance_helper'

describe "channels", type: :request do
  it "can be visited" do
    user = sign_in_user create :active_user
    channel = create(:channel, created_by: user.graph_user)

    visit channel_path(user, channel)

    page.should have_content(channel.title)
  end
end
