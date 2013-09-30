require_relative '../../../app/interactors/util/validations.rb'

describe Util::Validations do
  before do
    stub_const 'DummyClass', Class.new { include Util::Validations }
    stub_const 'Pavlov::ValidationError', RuntimeError
  end

  subject {DummyClass.new}

  describe '#validate_string_length' do
    it 'should not raise an error when the string is not over the given length' do
      subject.validate_string_length(:some_var, 'aa', 2)
    end

    it 'should not raise an error when the string longer than the given length' do
      expect{subject.validate_string_length(:some_var, 'aaa', 2)}
        .to raise_error(Pavlov::ValidationError,
          "some_var should not be longer than 2 characters.")
    end
  end

  describe '#validate_non_empty_list' do
    it 'does not raise for a nonempty list' do
      subject.validate_non_empty_list :list, [1]
    end
    it 'raises for nil' do
      expect{subject.validate_non_empty_list(:list, nil)}
        .to raise_error(Pavlov::ValidationError,
          "list should be a list")
    end
    it 'raises for a string' do
      expect{subject.validate_non_empty_list(:list, 'foo')}
        .to raise_error(Pavlov::ValidationError,
          "list should be a list")
    end
    it 'raises for an empty list' do
      expect{subject.validate_non_empty_list(:list, [])}
        .to raise_error(Pavlov::ValidationError,
          "list should not be empty")
    end
  end
end
