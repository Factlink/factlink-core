require_relative '../../../app/interactors/pavlov.rb'

describe Pavlov::Operation do
  let :dummy_class do
  end

  describe '#arguments' do
    describe "creates an initializer which" do
      it "saves arguments passed to instance variables" do
        dummy_class = Class.new do
          include Pavlov::Operation
          arguments :geert
        end

        x = dummy_class.new 'argument'
        expect(x.send(:instance_variable_get,'@geert')).to eq('argument')
      end

      it "saves arguments passed to instance variables in order" do
        dummy_class = Class.new do
          include Pavlov::Operation
          arguments :var1, :var2
        end

        x = dummy_class.new 'VAR1', 'VAR2'
        expect(x.send(:instance_variable_get,'@var1')).to eq('VAR1')
        expect(x.send(:instance_variable_get,'@var2')).to eq('VAR2')
      end

      it "calls validate if it exists" do
        dummy_class = Class.new do
          include Pavlov::Operation
          arguments
          def validate
            @x_val = :validate_was_called
          end
          def validate_was_called
            @x_val
          end
        end
        x = dummy_class.new
        expect(x.validate_was_called).to eq(:validate_was_called)
      end
      it "calls check_authority" do
        dummy_class = Class.new do
          include Pavlov::Operation
          arguments
          def check_authority
            @x_val = :check_authority_was_called
          end
          def check_authority_was_called
            @x_val
          end
        end
        x = dummy_class.new
        expect(x.check_authority_was_called).to eq(:check_authority_was_called)
      end
    end
  end
end