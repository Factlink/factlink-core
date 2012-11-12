require 'spec_helper'

describe Janitor::CleanActivityList do
  describe ".perform" do
    before do
      @u = create :graph_user

      @a1 = create :activity
      @a2 = create :activity

      @a1.add_to_list_with_score(@u.stream_activities)
      @u.stream_activities.key.zadd 10, 230502378906

    end

    it "should remove topics without channels" do
      @u.stream_activities.ids.should =~ [@a1.id,"230502378906"]
      Activity[230502378906].should be_nil
      Janitor::CleanActivityList.perform(@u.stream_activities.key.to_s)
      @u.stream_activities.ids.should =~ [@a1.id]
    end
  end
end