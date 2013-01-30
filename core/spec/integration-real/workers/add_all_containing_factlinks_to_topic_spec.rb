require 'spec_helper'

describe AddAllContainingFactlinksToTopic do
  include Pavlov::Helpers

  before do
    @user1 = create :user
    @user2 = create :user
    @user3 = create :user

    @channel1 = create :channel, title: "Channel Title", created_by: @user1.graph_user
    @channel2 = create :channel, title: "Channel Title", created_by: @user2.graph_user
    @channel3 = create :channel, title: "Channel Title", created_by: @user3.graph_user

    @slug_title = @channel1.slug_title

    @fact1 = create :fact
    @fact2 = create :fact
    @fact3 = create :fact

    interactor :"channels/add_fact", @fact1, @channel1
    interactor :"channels/add_fact", @fact2, @channel2
    interactor :"channels/add_fact", @fact3, @channel3
  end

  it 'adds all containing Factlinks to the Topics Facts' do
    Topic.redis.del Topic.redis[@slug_title][:facts]

    expect(interactor(:"topics/facts", @slug_title, nil, nil).length).to eq 0

    AddAllContainingFactlinksToTopic.perform(Topic.find_by(slug_title: @slug_title).id)

    expect(interactor(:"topics/facts", @slug_title, nil, nil).length).to eq 3
  end

  def pavlov_options
    {
      no_current_user: true,
      current_user: true
    }
  end
end