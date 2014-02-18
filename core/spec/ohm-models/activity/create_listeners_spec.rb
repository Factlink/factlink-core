require "spec_helper"

describe 'activity queries' do
  include RedisSupport
  let(:gu1) { create(:full_user).graph_user }
  let(:gu2) { create(:full_user).graph_user }

  include PavlovSupport

  let(:pavlov_options) { {ability: (double can?: true)} }

  before do
    # TODO: remove this once creating an activity does not cause an email to be sent
    stub_const 'Interactors::SendMailForActivity', Class.new
    Interactors::SendMailForActivity.stub(new: double(call: nil),
                                          attribute_set: [double(name:'pavlov_options'),double(name: 'activity')])
  end

  describe :comments do
    context "creating a comment" do
      it "creates a notification for the interacting users" do
        fact = create(:fact)
        fact.add_opinion(:believes, gu1)

        user = create(:full_user)

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
        user = create(:full_user)

        interactor = Interactors::Comments::Create.new(fact_id: fact.id.to_i,
                                                       type: 'believes', content: 'tex message',
                                                       pavlov_options: { current_user: user })
        comment = interactor.call

        gu1.stream_activities.map(&:to_hash_without_time).should == [
          {user: user.graph_user, action: :created_comment, subject: Comment.find(comment.id), object: fact }
        ]
      end
      it "creates a stream activity for the user's followers" do
        fact = create(:fact)
        user = create(:full_user)

        as(gu1.user) do |pavlov|
          pavlov.interactor(:'users/follow_user', user_to_follow_username: user.username)
        end

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
    let(:current_user) { create :full_user }

    context "creating a sub comment on a comment" do
      context "gu1 believes the topfact" do
        it "creates a stream activity" do
          comment, sub_comment = ()

          fact = create :fact

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          fact.add_opinion :believes, gu1

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.stream_activities.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end

        it "does not create a notification" do
          comment, sub_comment = ()

          fact = create :fact

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          fact.add_opinion :believes, gu1

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.notifications.map(&:to_hash_without_time).should == [
          ]
        end

        it "creates a stream activity for the user's followers" do
          comment, sub_comment = ()

          fact = create :fact

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'users/follow_user', user_to_follow_username: current_user.username)
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.stream_activities.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end
      end

      context "gu1 believes the comment" do
        it "creates a stream activity" do
          comment, sub_comment = ()

          fact = create :fact

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'comments/update_opinion', comment_id: comment.id.to_s, opinion: 'believes')
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.stream_activities.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end

        it "creates a notification" do
          comment, sub_comment = ()

          fact = create :fact

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'comments/update_opinion', comment_id: comment.id.to_s, opinion: 'believes')
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.notifications.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end
      end

      context "gu1 has added a subcomment to the comment" do
        it "creates a stream activity" do
          comment, sub_comment = ()

          fact = create :fact

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.stream_activities.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end

        it "creates a notification" do
          comment, sub_comment = ()

          fact = create :fact

          as(current_user) do |pavlov|
            comment = pavlov.interactor(:'comments/create', fact_id: fact.id.to_i, type: 'disbelieves', content: 'content')
          end

          as(gu1.user) do |pavlov|
            pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
          end

          as(current_user) do |pavlov|
            sub_comment = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
          end

          gu1.notifications.map(&:to_hash_without_time).should == [
            {user: current_user.graph_user, action: :created_sub_comment, subject: SubComment.find(sub_comment.id), object: fact }
          ]
        end
      end
    end
  end

  describe 'following a person' do
    let(:user)     { create(:full_user) }
    let(:followee) { create(:full_user) }
    it 'creates a notification for the followed person' do
      as(user) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_to_follow_username: followee.username)
      end
      followee_notifications = followee.graph_user.notifications.map(&:to_hash_without_time)
      expect(followee_notifications).to eq [
        {user: user.graph_user, action: :followed_user, subject: followee.graph_user}
      ]
    end
    it 'creates a stream activity for your followers' do
      follower = create(:full_user)

      as(follower) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_to_follow_username: user.username)
      end
      as(user) do |pavlov|
        pavlov.interactor(:'users/follow_user', user_to_follow_username: followee.username)
      end
      follower_stream_activities = follower.graph_user.stream_activities.map(&:to_hash_without_time)
      expect(follower_stream_activities).to eq [
        {user: user.graph_user, action: :followed_user, subject: followee.graph_user}
      ]
    end
  end
end
