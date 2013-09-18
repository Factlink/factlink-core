require "spec_helper"

describe 'activity queries' do
  include AddFactToChannelSupport
  include RedisSupport
  let(:gu1) { create(:active_user).graph_user }
  let(:gu2) { create(:active_user).graph_user }

  include PavlovSupport

  let(:pavlov_options) { {ability: (double can?: true)} }

  before do
    # TODO: remove this once creating an activity does not cause an email to be sent
    stub_const 'Interactors::SendMailForActivity', Class.new
    Interactors::SendMailForActivity.stub(new: double(call: nil),
      attribute_set: [double(name:'pavlov_options'),double(name: 'activity')])
  end

  describe ".channel" do
    it "should return activity for when a channel followed this channel" do
      ch1 = create :channel
      ch2 = create :channel

      Interactors::Channels::AddSubchannel.new(channel_id: ch1.id,
        subchannel_id: ch2.id, pavlov_options: pavlov_options).call
      ch2.activities.map(&:to_hash_without_time).should == [
        {user: ch1.created_by, action: :added_subchannel, subject: ch2, object: ch1}
      ]
    end

    context 'seeing channels' do
      let(:gu1) { create(:seeing_channels_user).graph_user }
      let(:gu2) { create(:seeing_channels_user).graph_user }

      it "should return activity for all users following a channel of User1 when User1 creates a new channel" do
        ch1 = create :channel, created_by: gu1
        ch2 = create :channel, created_by: gu2

        Interactors::Channels::AddSubchannel.new(channel_id: ch1.id.to_s,
          subchannel_id: ch2.id.to_s, pavlov_options: pavlov_options).call
        ch3 = create :channel, created_by: gu2

        # Channel should not be empty
        f1 = create :fact
        add_fact_to_channel f1, ch3

        gu1.stream_activities.map(&:to_hash_without_time).should == [
          {user: gu2, action: :created_channel, subject: ch3}
        ]
      end

      it "should return only one created activity when adding subchannels" do
        ch1 = create :channel, created_by: gu1
        ch2 = create :channel, created_by: gu2

        Interactors::Channels::AddSubchannel.new(channel_id: ch1.id,
          subchannel_id: ch2.id, pavlov_options: pavlov_options).call
        ch3 = create :channel, created_by: gu2

        4.times do
          Interactors::Channels::AddSubchannel.new(channel_id: ch3.id,
            subchannel_id: (create :channel).id, pavlov_options: pavlov_options).call
        end

        stream_activities = gu1.stream_activities.map(&:to_hash_without_time)
        expect(stream_activities).to eq [
          {user: gu2, action: :created_channel, subject: ch3}
        ]
      end
    end

    it "should *not* return activity for all users following a channel of User1 when User1 creates a new channel" do
      ch1 = create :channel, created_by: gu1
      ch2 = create :channel, created_by: gu2

      Interactors::Channels::AddSubchannel.new(channel_id: ch1.id,
        subchannel_id: ch2.id, pavlov_options: pavlov_options).call
      ch3 = create :channel, created_by: gu2

      # Channel should not be empty
      f1 = create :fact
      add_fact_to_channel f1, ch3

      gu1.stream_activities.map(&:to_hash_without_time).should == []
    end

    it "should *not* return created activity when adding subchannels" do
      ch1 = create :channel, created_by: gu1
      ch2 = create :channel, created_by: gu2

      Interactors::Channels::AddSubchannel.new(channel_id: ch1.id,
        subchannel_id: ch2.id, pavlov_options: pavlov_options).call
      ch3 = create :channel, created_by: gu2

      4.times do
        Interactors::Channels::AddSubchannel.new(channel_id: ch3.id,
          subchannel_id: (create :channel).id, pavlov_options: pavlov_options).call
      end

      stream_activities = gu1.stream_activities.map(&:to_hash_without_time)
      expect(stream_activities).to eq []
    end

    [:supporting, :weakening].each do |type|
      it "should return activities about facts which have received extra #{type} evidence" do
        ch1 = create :channel
        f1 = create :fact
        f2 = create :fact
        add_fact_to_channel f1, ch1
        f1.add_evidence type, f2, gu1

        @nr = number_of_commands_on Ohm.redis do
          @activities = ch1.activities.map(&:to_hash_without_time)
        end
        @nr.should < 25
        @activities.should == [
          {user: gu1, action: :"added_#{type}_evidence", subject: f2, object: f1}
        ]
      end
    end
  end

  describe ".user" do
    context 'seeing channels' do
      let(:gu1) { create(:seeing_channels_user).graph_user }
      let(:gu2) { create(:seeing_channels_user).graph_user }

      it "should return notification when a user follows your channel" do
        ch1 = create :channel, created_by: gu1
        ch2 = create :channel, created_by: gu2

        Interactors::Channels::AddSubchannel.new(channel_id: ch1.id,
          subchannel_id: ch2.id, pavlov_options: pavlov_options).call
        ch2.created_by.notifications.map(&:to_hash_without_time).should == [
          {user: ch1.created_by, action: :added_subchannel, subject: ch2, object: ch1}
        ]
      end

      it "should return stream activity when a user follows your channel" do
        ch1 = create :channel, created_by: gu1
        ch2 = create :channel, created_by: gu2

        Interactors::Channels::AddSubchannel.new(channel_id: ch1.id,
          subchannel_id: ch2.id, pavlov_options: pavlov_options).call
        ch2.created_by.stream_activities.map(&:to_hash_without_time).should == [
          {user: ch1.created_by, action: :added_subchannel, subject: ch2, object: ch1}
        ]
      end
    end

    it "should *not* return notification when a user follows your channel" do
      ch1 = create :channel, created_by: gu1
      ch2 = create :channel, created_by: gu2

      Interactors::Channels::AddSubchannel.new(channel_id: ch1.id,
        subchannel_id: ch2.id, pavlov_options: pavlov_options).call
      ch2.created_by.notifications.map(&:to_hash_without_time).should == []
    end

    it "should *not* return stream activity when a user follows your channel" do
      ch1 = create :channel, created_by: gu1
      ch2 = create :channel, created_by: gu2

      Interactors::Channels::AddSubchannel.new(channel_id: ch1.id,
        subchannel_id: ch2.id, pavlov_options: pavlov_options).call
      ch2.created_by.stream_activities.map(&:to_hash_without_time).should == []
    end

    it "should only return other users activities, not User his own activities" do
      f1 = create :fact
      f1.created_by.stream_activities.key.del # delete other activities

      f1.add_opinion(:believes, gu1)
      Activity::Subject.activity(gu1, OpinionType.real_for(:believes), f1)

      f1.add_opinion(:disbelieves, f1.created_by)
      Activity::Subject.activity(f1.created_by, OpinionType.real_for(:disbelieves), f1)

      f1.created_by.stream_activities.map(&:to_hash_without_time).should == [
        {user: gu1, action: :believes, subject: f1},
      ]
    end

    it "should return activity when a user adds a Fact to your channel" do
      f = create :fact, created_by: gu1
      f.created_by.stream_activities.key.del # delete other activities

      ch = create :channel, created_by: gu2
      add_fact_to_channel f, ch

      notification = gu1.stream_activities.map(&:to_hash_without_time).should == [
        {:user => gu2, :action => :added_fact_to_channel, :subject => f, :object => ch}
      ]
    end

    it "should return a :added_first_factlink activity when the users' first factlink is created" do
      f1 = create :fact, created_by: gu1

      gu1.stream_activities.map(&:to_hash_without_time).should == [
        {user: gu1, action: :added_first_factlink, subject: f1}
      ]
    end

    [:supporting, :weakening].each do |type|
      it "should return activity when a users adds #{type} evidence to a fact that you created" do
        f1 = create :fact
        f2 = create :fact
        f1.add_evidence type, f2, gu1
        f1.created_by.notifications.map(&:to_hash_without_time).should == [
          {user: gu1, action: :"added_#{type}_evidence", subject: f2, object: f1}
        ]
      end

      it "should return activity when a users adds #{type} evidence to a fact that you believed" do
        f1 = create :fact
        f1.add_opinion(:believes, gu1)
        Activity::Subject.activity(gu1, OpinionType.real_for(:believes), f1)

        f2 = create :fact
        f1.add_evidence type, f2, gu2
        gu1.notifications.map(&:to_hash_without_time).should == [
          {user: gu2, action: :"added_#{type}_evidence", subject: f2, object: f1}
        ]
      end

      it "should return activity when a users adds #{type} evidence to a fact that you supported" do
        f1 = create :fact
        f2 = create :fact
        f3 = create :fact
        f1.add_evidence :supporting, f2, gu1
        f1.add_evidence type, f3, gu2
        gu1.notifications.map(&:to_hash_without_time).should == [
          {user: gu2, action: :"added_#{type}_evidence", subject: f3, object: f1}
        ]
      end
    end
    [:believes, :doubts, :disbelieves].each do |opinion|
      it "should return activity when a user opinionates a fact of the user" do
        f1 = create :fact
        f1.created_by.stream_activities.key.del # delete other activities

        f1.add_opinion(opinion, gu1)
        Activity::Subject.activity(gu1, OpinionType.real_for(opinion), f1)

        f1.created_by.stream_activities.map(&:to_hash_without_time).should == [
            {user: gu1, action: opinion, subject: f1}
        ]
      end
    end
    it "should return an activity when a user accepts its invitation" do
      inviter = create :user

      u = create :user
      u.invited_by = inviter
      u.save

      u.approve_invited_user_and_create_activity

      u.graph_user.notifications.map(&:to_hash_without_time).should == [
        {user: inviter.graph_user, action: :invites, subject: u.graph_user}
      ]
    end
  end

  describe :messages do
    context "creating a conversation" do
      it "creates a notification for the receiver" do
        f  = create(:fact)
        u1 = create(:user)
        u2 = create(:user)

        interactor = Interactors::CreateConversationWithMessage.new(fact_id: f.id.to_s,
          recipient_usernames: [u1.username, u2.username], sender_id: u1.id.to_s,
          content: 'this is a message', pavlov_options: { current_user: u1 })
        interactor.stub(track_mixpanel: nil)
        conversation = interactor.call

        u1.graph_user.notifications.map(&:to_hash_without_time).should == []
        u2.graph_user.notifications.map(&:to_hash_without_time).should == [
          {user: u1.graph_user, action: :created_conversation, subject: Conversation.find(conversation.id) }
        ]
      end
    end

    context "replying to a conversation" do
      it "creates a notification for the receiver" do
        c = create(:conversation_with_messages)
        u1 = c.recipients[0]
        u2 = c.recipients[1]

        interactor = Interactors::ReplyToConversation.new(conversation_id: c.id.to_s,
          sender_id: u1.id.to_s, content: 'this is a message', pavlov_options: { current_user: u1 })
        interactor.stub(track_mixpanel: nil)
        message = interactor.call

        u1.graph_user.notifications.map(&:to_hash_without_time).should == []
        u2.graph_user.notifications.map(&:to_hash_without_time).should == [
          {user: u1.graph_user, action: :replied_message, subject: Message.find(message.id) }
        ]
      end
    end

  end

  describe :comments do
    context "creating a comment" do
      it "creates a notification for the interacting users" do
        fact = create(:fact)
        fact.add_opinion(:believes, gu1)

        user = create(:user)

        interactor = Interactors::Comments::Create.new(fact_id: fact.id.to_i,
          type: 'believes', content: 'tex message',
          pavlov_options: { current_user: user })
        comment = interactor.call

        gu1.notifications.map(&:to_hash_without_time).should == [
          {user: user.graph_user, action: :created_comment, subject: Comment.find(comment.id), object: fact }
        ]
      end
      it "creates a stream activity for the interacting users" do
        fact = create(:fact)
        fact.add_opinion(:believes, gu1)
        user = create(:user)

        interactor = Interactors::Comments::Create.new(fact_id: fact.id.to_i,
          type: 'believes', content: 'tex message',
          pavlov_options: { current_user: user })
        comment = interactor.call

        gu1.stream_activities.map(&:to_hash_without_time).should == [
          {user: user.graph_user, action: :created_comment, subject: Comment.find(comment.id), object: fact }
        ]
      end
    end

  end

  describe :sub_comments do
    let(:current_user) {create :user}

    context "creating a sub comment on a comment" do
      context "gu1 believes the topfact" do
        it "creates a stream activity" do
          comment, sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          fact.add_opinion :believes, gu1

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.stream_activities.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end

        it "does not create a notification" do
          comment, sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          fact.add_opinion :believes, gu1

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.notifications.map(&:to_hash_without_time).should == [
          ]
        end
      end

      context "gu1 believes the comment" do
        it "creates a stream activity" do
          comment, sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'comments/update_opinion', comment_id: comment.id.to_s, opinion: 'believes')
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.stream_activities.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end

        it "creates a notification" do
          comment, sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'comments/update_opinion', comment_id: comment.id.to_s, opinion: 'believes')
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.notifications.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end
      end

      context "gu1 has added a subcomment to the comment" do
        it "creates a stream activity" do
          comment, sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'content')
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.stream_activities.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end

        it "creates a notification" do
          comment, sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'content')
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_comment', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.notifications.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end
      end
    end

    context "creating a sub comment on a fact relation" do
      context "gu1 believes the topfact" do
        it "creates a stream activity" do
          sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          fact_relation = fact.add_evidence :supporting, create(:fact), current_user

          fact.add_opinion :believes, gu1

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: 'content')
          end

          gu1.stream_activities.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end

        it "does not create a notification" do
          sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          fact_relation = fact.add_evidence :supporting, create(:fact), current_user

          fact.add_opinion :believes, gu1

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: 'content')
          end

          gu1.notifications.map(&:to_hash_without_time).should == [
          ]
        end
      end

      context "gu1 believes the fact relation" do
        it "creates a stream activity" do
          sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          fact_relation = fact.add_evidence :supporting, create(:fact), current_user

          fact_relation.add_opinion :believes, gu1

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: 'content')
          end

          gu1.stream_activities.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end

        it "creates a notification" do
          sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          fact_relation = fact.add_evidence :supporting, create(:fact), current_user

          fact_relation.add_opinion :believes, gu1

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: 'content')
          end

          gu1.notifications.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end
      end

      context "gu1 has added a subcomment to the fact relation" do
        it "creates a stream activity" do
          sub_comment = ()

          fact = create :fact, created_by: current_user.graph_user

          fact_relation = fact.add_evidence :supporting, create(:fact), current_user

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: 'content')
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: 'content')
          end

          gu1.stream_activities.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end

        it "creates a notification" do
          sub_comment = ()
          fact = create :fact, created_by: current_user.graph_user

          fact_relation = fact.add_evidence :supporting, create(:fact), current_user

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: 'content')
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: 'content')
          end

          gu1.notifications.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]

        end
      end
    end
  end

  describe 'following a person' do
    let(:user)     { create(:active_user) }
    let(:followee) { create(:active_user) }
    it 'creates a notification for the followed person' do
      as(user) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_name: user.username, user_to_follow_user_name: followee.username)
      end
      followee_notifications = followee.graph_user.notifications.map(&:to_hash_without_time)
      expect(followee_notifications).to eq [
        {user: user.graph_user, action: :followed_user, subject: followee.graph_user}
      ]
    end
    it 'creates a stream activity for your followers' do
      follower = create(:active_user)

      as(follower) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_name: follower.username, user_to_follow_user_name: user.username)
      end
      as(user) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_name: user.username, user_to_follow_user_name: followee.username)
      end
      follower_stream_activities = follower.graph_user.stream_activities.map(&:to_hash_without_time)
      expect(follower_stream_activities).to eq [
        {user: user.graph_user, action: :followed_user, subject: followee.graph_user}
      ]
    end
  end

  describe "following a person" do
      it "creates a activity when a user you follow adds a factlink to a channel" do
        gu3 =create(:active_user).graph_user
        UserFollowingUsers.new(gu2.id).follow gu1.id

        f1 = create :fact, created_by: gu3

        ch1 = create :channel, created_by: gu1
        add_fact_to_channel f1, ch1

        gu2.stream_activities.map(&:to_hash_without_time).should == [
          {user: gu1, action: :added_fact_to_channel, subject: f1, object: ch1}
        ]
      end
    end
end
