require 'spec_helper'

describe GraphUser do

  subject {FactoryGirl.create(:user).graph_user}

  context "Initially" do
    its(:facts) {should == []}
  end


  [:beliefs,:doubts,:disbeliefs].each do |type|
  end
end
