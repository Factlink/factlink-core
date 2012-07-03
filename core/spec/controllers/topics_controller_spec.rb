require 'spec_helper'

describe TopicsController do
  render_views

  let (:user) { FactoryGirl.create(:user) }

  let (:t1)   { FactoryGirl.create(:topic) }

end
