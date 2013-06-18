require 'spec_helper'

describe Janitor::CleanActivityList do
  describe ".perform" do
    it "should remove activities which no longer exist from the list" do
      user = create :graph_user

      activity1 = create :activity
      create :activity

      activity1.add_to_list_with_score(user.stream_activities)
      user.stream_activities.key.zadd 10, 230_502_378_906

      user.stream_activities.ids.should =~ [activity1.id,"230502378906"]
      Activity[230_502_378_906].should be_nil
      Janitor::CleanActivityList.perform(user.stream_activities.key.to_s)
      user.stream_activities.ids.should =~ [activity1.id]
    end
  end
end
