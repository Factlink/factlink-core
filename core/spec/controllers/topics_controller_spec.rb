require 'spec_helper'

describe TopicsController do
  render_views

  let (:user) { FactoryGirl.create(:user) }

  let (:t1)   { FactoryGirl.create(:topic) }

  describe :related_users do
    it "should check permisions" do

      should_check_can :show, t1

      get 'related_users', :id => t1.slug_title
      response.should be_success
    end

  end

end
