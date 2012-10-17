require_relative '../../../app/interactors/pavlov.rb'

describe Pavlov::Operation do
  let :dummy_class do
  end

  describe '#arguments' do
    it "should ensure that the initializer saves arguments passed to instance variables" do
      dummy_class = Class.new do
        include Pavlov::Operation
        arguments :geert
      end

      x = dummy_class.new 'argument'
      expect(x.send(:instance_variable_get,'@geert')).to eq('argument')
    end

    it "should ensure that the initializer saves arguments passed to instance variables in order" do
      dummy_class = Class.new do
        include Pavlov::Operation
        arguments :var1, :var2
      end

      x = dummy_class.new 'VAR1', 'VAR2'
      expect(x.send(:instance_variable_get,'@var1')).to eq('VAR1')
      expect(x.send(:instance_variable_get,'@var2')).to eq('VAR2')
    end
  end
end