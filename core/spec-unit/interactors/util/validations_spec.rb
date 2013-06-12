require_relative '../../../app/interactors/util/validations.rb'

describe Util::Validations do
  before do
    stub_const 'DummyClass', Class.new { include Util::Validations }
    stub_const 'Pavlov::ValidationError', RuntimeError
  end

  describe '#validate_string_length' do
    it 'should not raise an error when the string is not over the given length' do
      obj = DummyClass.new
      obj.validate_string_length(:some_var, 'aa', 2)
    end

    it 'should not raise an error when the string longer than the given length' do
      obj = DummyClass.new

      expect{obj.validate_string_length(:some_var, 'aaa', 2)}
        .to raise_error(Pavlov::ValidationError,
          "some_var should not be longer than 2 characters.")
    end
  end
end
