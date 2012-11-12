require 'spec_helper'

describe SetLastInteractionForUser do

  describe ".perform" do

    before do
      @user = create :user
      @current_interaction_at = @user.last_interaction_at
    end

    it "should update the user last_interaction_at" do
      SetLastInteractionForUser.perform(@user.id, DateTime.now.to_i)

      @user.reload
      @user.last_interaction_at.should > @current_interaction_at
    end

  end

end