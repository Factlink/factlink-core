require 'hashie'
require 'active_support'
require_relative '../../../app/interactors/kill_object.rb'

describe KillObject do
  describe '#kill' do
    it "retains requested methods" do
      test = mock('test', foo:'bar')
      dead = KillObject.kill test, [:foo]
      expect(dead.foo).to eq('bar')
    end
    it "drops methods which are not requested" do
      test = mock('test', foo:'bar')
      dead = KillObject.kill test, [:harrie]
      expect(dead).to_not respond_to(:foo)
    end
    it "adds extra fields defined in extra_fields hash" do
      test = mock('test', foo:'bar')
      dead = KillObject.kill test, [:foo], pinda: 'kaas'
      expect(dead.foo).to eq('bar')
      expect(dead.pinda).to eq('kaas')
    end
  end
end
