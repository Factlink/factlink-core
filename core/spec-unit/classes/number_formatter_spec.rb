require_relative '../../app/classes/number_formatter'

describe NumberFormatter do
  describe '.as_authority' do
    it 'should return "0.0" when the number is 0' do
      number = 0

      expect(NumberFormatter.new(number).as_authority).to eq "0.0"
    end

    it 'should return "1.0" when the number is 1' do
      number = 1
      expect(NumberFormatter.new(number).as_authority).to eq "1.0"
    end

    it 'should round' do
      number = 3.3333
      expect(NumberFormatter.new(number).as_authority).to eq "3.3"
    end
  end
end
