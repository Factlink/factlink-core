require_relative '../../app/entities/dead_fact_wheel.rb'

describe DeadFactWheel do
  describe "#{}is_user_opinion" do
    it "returns true if this is the useropinion" do
      wheel = DeadFactWheel.new 0,0,0,0, :believes
      expect(wheel.is_user_opinion(:believe)).to be_true
    end
    it "returns true if this is the useropinion" do
      wheel = DeadFactWheel.new 0,0,0,0, :believes
      expect(wheel.is_user_opinion(:disbelieve)).to be_false
    end
  end
end
