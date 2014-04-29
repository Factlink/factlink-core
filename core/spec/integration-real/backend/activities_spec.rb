require "spec_helper"

describe 'activity queries' do
  include PavlovSupport

  let(:current_user) { create :user, :confirmed, receives_mailed_notifications: true }
  let(:other_user) { create :user }

  before :each do
    FactoryGirl.reload

    @mails_by_username_and_activity = []
    SendActivityMailToUser.stub(:new) do
      job = double
      job.stub async: job
      job.stub(:perform) do |user_id, activity_id|
        @mails_by_username_and_activity << {
          username: User.find(user_id).username,
          subject_type: Activity.find(activity_id).subject_type,
          action: Activity.find(activity_id).action
        }
      end
      job
    end
  end

  describe :comments do
    context "creating a comment" do
      it "creates a notification for users that find the fact interesting" do
        fact_data = create :fact_data
        as(current_user) do |pavlov|
          pavlov.send_mails = true
          pavlov.interactor(:'facts/set_interesting', fact_id: fact_data.fact_id.to_s)
        end

        comment = nil
        as(create :user) do |pavlov|
          pavlov.send_mails = true
          comment = pavlov.interactor(:'comments/create', fact_id: fact_data.fact_id.to_s, type: 'believes', content: 'content')
        end

        verify { @mails_by_username_and_activity }
      end
      it "creates a stream activity for users that find the fact interesting" do
        fact_data = create :fact_data
        as(current_user) do |pavlov|
          pavlov.interactor(:'facts/set_interesting', fact_id: fact_data.fact_id.to_s)
        end

        comment = nil
        as(create :user) do |pavlov|
          comment = pavlov.interactor(:'comments/create', fact_id: fact_data.fact_id.to_s, type: 'believes', content: 'content')
        end

        as(current_user) do |pavlov|
          verify { pavlov.interactor(:'feed/personal') }
        end
      end
      it "creates a stream activity for the user's followers" do
        fact_data = create :fact_data
        followee = create :user

        as(current_user) do |pavlov|
          pavlov.interactor(:'users/follow_user', username: followee.username)
        end

        comment = nil
        as(followee) do |pavlov|
          comment = pavlov.interactor(:'comments/create', fact_id: fact_data.fact_id.to_s, type: 'believes', content: 'content')
        end

        as(current_user) do |pavlov|
          verify { pavlov.interactor(:'feed/personal') }
        end
      end
    end

  end

  describe :sub_comments do
    context "creating a sub comment on a comment" do
      it "creates a stream activity for those that find the top fact interesting" do
        comment, sub_comment = ()

        fact_data = create :fact_data

        as(other_user) do |pavlov|
          comment = pavlov.interactor(:'comments/create', fact_id: fact_data.fact_id.to_s, type: 'disbelieves', content: 'content')
        end

        as(current_user) do |pavlov|
          pavlov.interactor(:'facts/set_interesting', fact_id: fact_data.fact_id.to_s)
        end

        as(other_user) do |pavlov|
          sub_comment = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
        end

        as(current_user) do |pavlov|
          verify { pavlov.interactor(:'feed/personal') }
        end
      end

      it "creates a notification for those that find the top fact interesting" do
        comment, sub_comment = ()

        fact_data = create :fact_data

        as(other_user) do |pavlov|
          pavlov.send_mails = true
          comment = pavlov.interactor(:'comments/create', fact_id: fact_data.fact_id.to_s, type: 'disbelieves', content: 'content')
        end

        as(current_user) do |pavlov|
          pavlov.send_mails = true
          pavlov.interactor(:'facts/set_interesting', fact_id: fact_data.fact_id.to_s)
        end

        as(other_user) do |pavlov|
          pavlov.send_mails = true
          sub_comment = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
        end

        verify { @mails_by_username_and_activity }
      end

      it "creates a stream activity for the user's followers" do
        comment, sub_comment = ()

        fact_data = create :fact_data

        as(create :user) do |pavlov|
          comment = pavlov.interactor(:'comments/create', fact_id: fact_data.fact_id.to_s, type: 'disbelieves', content: 'content')
        end

        as(current_user) do |pavlov|
          pavlov.interactor(:'users/follow_user', username: other_user.username)
        end

        as(other_user) do |pavlov|
          sub_comment = pavlov.interactor(:'sub_comments/create', comment_id: comment.id.to_s, content: 'content')
        end

        as(current_user) do |pavlov|
          verify { pavlov.interactor(:'feed/personal') }
        end
      end
    end
  end

  describe 'following a person' do
    let(:follower) { create(:user) }

    it 'creates a notification for the followed person' do
      as(follower) do |pavlov|
        pavlov.send_mails = true
        pavlov.interactor(:'users/follow_user', username: current_user.username)
      end

      verify { @mails_by_username_and_activity }
    end
    it 'creates a stream activity for your followers' do
      as(follower) do |pavlov|
        pavlov.interactor(:'users/follow_user', username: current_user.username)
      end
      as(current_user) do |pavlov|
        pavlov.interactor(:'users/follow_user', username: (create :user).username)
      end

      as(follower) do |pavlov|
        verify { pavlov.interactor(:'feed/personal') }
      end
    end
  end
end
