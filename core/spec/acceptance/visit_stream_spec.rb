require 'acceptance_helper'

feature "visiting the stream" do
  include Acceptance::NavigationHelper
  include Acceptance::ChannelHelper
  include Acceptance::FactHelper
  include PavlovSupport

  background do
    @user = create :active_user
  end

  scenario "adding first fact" do
    channel = backend_create_channel
    factlink = backend_create_fact
    backend_add_fact_to_channel factlink, channel

    sign_in_user @user
    go_to_stream

    page.should have_content('just added their first Factlink')
    page.should have_content(factlink.to_s)
  end

end
