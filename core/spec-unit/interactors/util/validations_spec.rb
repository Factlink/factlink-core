require 'pavlov_helper'
require_relative '../../../app/interactors/util/validations.rb'

describe Util::Validations do
  before do
    stub_const 'DummyClass', Class.new
    class DummyClass
      include Util::Validations
      def initialize(errors)
        @errors = errors
      end
      attr_reader :errors
    end
    stub_const 'Pavlov::ValidationError', RuntimeError
  end

  subject {DummyClass.new}

  describe '#validate_string_length' do
    it 'should not raise an error when the string is not over the given length' do
      obj = DummyClass.new(double)
      obj.validate_string_length(:some_var, 'aa', 2)
    end

    it 'should raise an error when the string longer than the given length' do
      errors = double
      obj = DummyClass.new(errors)

      expect(errors)
        .to receive(:add)
              .with(:some_var, 'should not be longer than 2 characters.')

      obj.validate_string_length(:some_var, 'aaa', 2)
    end
  end

  describe '#validate_non_empty_list' do
    subject {DummyClass.new(errors)}
    let(:errors) { double }
    it 'does not raise for a nonempty list' do
      subject.validate_non_empty_list :list, [1]
    end
    it 'raises for nil' do
      expect(errors).to receive(:add).with(:list, 'should be a list')

      subject.validate_non_empty_list(:list, nil)
    end
    it 'raises for a string' do
      expect(errors).to receive(:add).with(:list, 'should be a list')
      subject.validate_non_empty_list(:list, 'foo')
    end
    it 'raises for an empty list' do
      expect(errors).to receive(:add).with(:list, 'should not be empty')
      subject.validate_non_empty_list(:list, [])
    end
  end
end
