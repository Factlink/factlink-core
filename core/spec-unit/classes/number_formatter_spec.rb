require_relative '../../app/classes/number_formatter'

describe NumberFormatter do
  describe '.as_authority' do
    context "when the number is positive" do
      it 'should return "0.0" when the number is 0' do
        number = 0
        expect(NumberFormatter.new(number).as_authority).to eq "0.0"
      end

      it 'should return "1.0" when the number is 1' do
        number = 1
        expect(NumberFormatter.new(number).as_authority).to eq "1.0"
      end

      it 'should round to 1 decimal' do
        number = 3.3333
        expect(NumberFormatter.new(number).as_authority).to eq "3.3"
      end

      it 'should round digits above 999 and below 2000 to 1k' do
        number = 1000
        expect(NumberFormatter.new(number).as_authority).to eq "1k"

        other_number = 1999
        expect(NumberFormatter.new(other_number).as_authority).to eq "1k"
      end

      it 'should not show decimals when the number is > 10' do
        number = 10
        expect(NumberFormatter.new(number).as_authority).to eq "10"
      end
    end

    context "when the number is negative" do
      it 'should return "-1.0" when the number is -1' do
        number = -1
        expect(NumberFormatter.new(number).as_authority).to eq "-1.0"
      end

      it 'should round to 1 decimal' do
        number = -3.3333
        expect(NumberFormatter.new(number).as_authority).to eq "-3.3"
      end

      it "should round digits below -999 and above to -1k" do
        number = -1000
        expect(NumberFormatter.new(number).as_authority).to eq "-1k"

        other_number = -1999
        expect(NumberFormatter.new(other_number).as_authority).to eq "-1k"
      end

      it "should not show decimals when the number is < -10" do
        number = -10
        expect(NumberFormatter.new(number).as_authority).to eq "-10"
      end
    end
  end
end
