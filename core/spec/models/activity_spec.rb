require 'spec_helper'

describe Activity do
  let(:gu) { create :user }
  let(:gu2) { create :user }
  let(:gu3) { create :user }

  describe "still_valid?" do
    it "should be valid for an activity with everything set" do
      Backend::Activities.create(user_id: gu.id, action: :followed_user, subject: gu2, time: Time.at(0), send_mails: false)
      activity = Activity.last
      expect(activity).to be_still_valid
    end

    it "should not be valid if the user is deleted" do
      deleted_user = create :user, deleted: true
      Backend::Activities.create(user_id: deleted_user.id, action: :followed_user, time: Time.at(0), send_mails: false)
      activity = Activity.last
      expect(activity).to_not be_still_valid
    end

    it "should not be valid if the subject is deleted" do
      Backend::Activities.create(user_id: gu.id, action: :followed_user, subject: gu2, time: Time.at(0), send_mails: false)
      activity = Activity.last
      gu2.delete
      expect(activity).to_not be_still_valid
    end
  end
end
