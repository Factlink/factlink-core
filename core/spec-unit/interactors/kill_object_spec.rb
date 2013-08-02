require 'active_support'
require_relative '../../app/interactors/kill_object.rb'

describe KillObject do
  describe '#kill' do
    it "retains requested methods" do
      test = double('test', foo:'bar')
      dead = KillObject.kill :name, test, [:foo]
      expect(dead.foo).to eq('bar')
    end
    it "drops methods which are not requested" do
      test = double('test', foo:'bar')
      dead = KillObject.kill :name, test, [:harrie]
      expect(dead).to_not respond_to(:foo)
    end
    it "adds extra fields defined in extra_fields hash" do
      test = double('test', foo:'bar')
      dead = KillObject.kill :name, test, [:foo], pinda: 'kaas'
      expect(dead.foo).to eq('bar')
      expect(dead.pinda).to eq('kaas')
    end
    it "fixes the to_json method on an open_struct" do
      test = double('test', foo:'bar')
      dead = KillObject.kill :name, test, [:foo], pinda: 'kaas'
      test_json = 'test json'

      dead.send(:table).should_receive(:to_json).and_return(test_json)

      dead.to_json.should eq test_json
    end
    it "stores the dead object name" do
      test = double('test', foo:'bar')
      dead = KillObject.kill :name, test, [:foo]
      expect(dead.dead_object_name).to eq(:name)
    end
  end
end
