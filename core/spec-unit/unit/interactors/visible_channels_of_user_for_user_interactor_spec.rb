require 'spec_helper'

describe VisibleChannelsOfUserForUserInteractor do
  describe '.execute' do
    it do
      user = mock
      ch1 = mock
      ch2 = mock
      topic_authority = mock
      containing_channels = mock

      VisibleChannelsOfUserForUserInteractor.any_instance.stub(authorized?: true)
      query = VisibleChannelsOfUserForUserInteractor.new user

      query.stub(
        topic_authority_for: topic_authority,
        visible_channels: [ch1, ch2],
        containing_channel_ids: containing_channels
      )

      query.should_receive(:kill_channel).with(ch1, topic_authority, containing_channels, user)
      query.should_receive(:kill_channel).with(ch2, topic_authority, containing_channels, user)
      query.execute
    end
  end

  pending do
    it do
      Query::VisibleChannelsOfUser.should_receive_new_and_execute.
        with(user).and_return([ch1, ch2])

      t1   = mock(:topic, slug_title: 'a')
      t2   = mock(:topic, slug_title: 'b')
      Query::TopicsForChannels.should_receive_new_and_execute.
        with([ch1, ch2]).and_return([t1, t2])

      query.should_receive(:kill_user).with(user).and_return(user)

      Query::AuthorityOnTopicFor.should_receive_new_and_execute.
        with(t1).and_return(10.0)

      Query::AuthorityOnTopicFor.should_receive_new_and_execute.
        with(t2).and_return(20.0)

      Query::ContainingChannelIdsForChannelAndUser.should_receive_new_and_execute.
        with()
    end
  end
end
