require_relative '../../../ohm_helper.rb'
require_relative '../../../../app/ohm-models/activity.rb'

describe Activity::Listener::Dsl do
  let(:al) { Activity::Listener.new }
  subject  { Activity::Listener::Dsl.new al }

  describe :new do
    it "should call execute when called with a block" do
      x = mock()
      x.should_receive(:foo)
      Activity::Listener::Dsl.new nil do x.foo end
    end
  end
  
  it "should set the activity_for on the listener" do
    al.should_receive(:activity_for=).with('Blob')
    subject.execute do
      activity_for 'Blob'
    end
  end
  
  it "should set the listname on the listener" do
    al.should_receive(:listname=).with(:notifications)
    subject.execute do
      named :notifications
    end
  end
  
  it "should be able to add a query" do
    al.queries.should_receive(:<<).with({ a: 'b' })
    subject.execute do
      activity({ :a => 'b'})
    end
  end
end