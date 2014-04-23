require 'spec_helper'

class Blob < OurOhm ;end
class Foo < OurOhm ;end

describe Activity do
  let(:b1) { Blob.create }
  let(:b2) { Blob.create }

  let(:gu) { create :user }
  let(:gu2) { create :user }
  let(:gu3) { create :user }

  describe "still_valid?" do
    it "should be valid for an activity with everything set" do
      activity = Activity.create(user_id: gu.id, action: :followed_user, subject: gu2, created_at: Time.at(0).utc.to_s)
      expect(activity).to be_still_valid
    end

    it "should be valid when the user is not set" do
      activity = Activity.create(action: :followed_user, subject: gu2, created_at: Time.at(0).utc.to_s)
      expect(activity).to be_still_valid
    end

    it "should be valid when the subject is unset/not set" do
      activity = Activity.create(user_id: gu.id, action: :followed_user, created_at: Time.at(0).utc.to_s)
      expect(activity).to be_still_valid
    end

    it "should not be valid if the user is deleted" do
      deleted_user = create :user, deleted: true
      activity = Activity.create(user_id: deleted_user.id, action: :followed_user, created_at: Time.at(0).utc.to_s)
      activity = Activity[activity.id]
      expect(activity).to_not be_still_valid
    end

    it "should not be valid if the subject is deleted" do
      activity = Activity.create(action: :followed_user, subject: gu2, created_at: Time.at(0).utc.to_s)
      gu2.delete
      expect(activity).to_not be_still_valid
    end
  end

  describe 'list management' do
    let(:activity) do Activity.create(
             :user_id => gu.id,
             :action => :followed_user,
             :subject => b1,
             :created_at => Time.at(0).utc.to_s
           )
    end
    let (:activity2) do Activity.create(
               :user_id => gu.id,
               :action => :followed_user,
               :subject => b1,
               :created_at => Time.at(0).utc.to_s
             )
    end

    describe :remove_from_containing_lists do
      it "should remove the activity from the list" do
        activity.add_to_list_with_score(gu.stream_activities)
        activity.remove_from_containing_sorted_sets
        gu.stream_activities.all.should == []
      end

      it "should leave other activities intact" do
        activity.add_to_list_with_score(gu.stream_activities)
        activity2.add_to_list_with_score(gu.stream_activities)
        activity.remove_from_containing_sorted_sets
        gu.stream_activities.all.should == [activity2]
      end
    end
    describe :delete do
      it 'should call remove_from_containing_sorted_sets' do
        activity.should_receive(:remove_from_containing_sorted_sets)
        activity.delete
      end
    end
  end
end
