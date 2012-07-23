require 'spec_helper'

describe Janitor::CleanActivityList do
  describe ".perform" do
    before do
      @u = create :graph_user

      @a1 = create :activity
      @a2 = create :activity

      @a1.add_to_list_with_score(@u.stream_activities)
      @a2.add_to_list_with_score(@u.stream_activities)

    end

    it "should remove topics without channels" do
      @a1.delete
      @u.stream_activities.ids.should =~ [@a1.id,@a2.id]
      Activity[@a1.id].should be_nil
      Janitor::CleanActivityList.perform(@u.stream_activities.key.to_s)
      @u.stream_activities.ids.should =~ [@a2.id]
    end
  end
end