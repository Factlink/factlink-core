require 'spec_helper'

describe Channel::CreatedFacts do

  describe :can_be_added_as_subchannel? do
    it "should be false" do
      subject.can_be_added_as_subchannel?.should be_false
    end
  end

end
