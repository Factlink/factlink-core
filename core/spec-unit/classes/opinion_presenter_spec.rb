require_relative '../../app/classes/opinion_presenter'

describe OpinionPresenter do
  before do
    stub_const 'NumberFormatter', Class.new
  end

  describe '#relevance' do
    it 'is 0 when the authority of the opinion is 0' do
      opinion = mock authority: 0, disbelieves: 0, believes: 0

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 0
    end

    it 'is 1 when every user beliefs and the sum of every users authority is 1' do
      opinion = stub :opinion, authority: 1, believes: 1, disbelieves: 0

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 1
    end

    it 'is -1 when every user disbeliefs and the sum of every users authority is 1' do
      opinion = stub :opinion, authority: 1, believes: 0, disbelieves: 1

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq(-1)
    end

    it 'is 0 when one user beliefs and one disbeliefs and the sum of every users authority is 1' do
      opinion = stub :opinion, authority: 1, believes: 1, disbelieves: 1

      op = OpinionPresenter.new opinion
      expect(op.relevance).to eq 0
    end
  end

  describe '#authority' do
    it 'Multiplies the value of opinion.type with the authority' do
      opinion = mock believes: 2, authority: 3

      op = OpinionPresenter.new opinion

      expect(op.authority(:believes)).to eq 6
    end
  end

  describe "#as_percentages_hash" do
    it "should use the NumberFormatter for the formatting of authority" do
      authority = 13
      friendly_authority = mock
      number_formatter = mock as_authority: friendly_authority

      NumberFormatter.stub(:new).with(authority).and_return(number_formatter)

      opinion = mock believes: 1, disbelieves: 0, doubts: 0, authority: authority
      calculated_friendly_authority = OpinionPresenter.new(opinion).as_percentages_hash[:authority]
      expect(calculated_friendly_authority).to eq friendly_authority
    end

    describe "rounds in a logical way" do
       before do
        NumberFormatter.stub(:new) do |a|
          mock as_authority: a
        end
       end
       {
        [0   ,0   ,100 ,0] => [0  ,0  ,100,0],
        [0   ,100 ,0   ,0] => [0  ,0  ,100,0],
        [100 ,0   ,0   ,0] => [0  ,0  ,100,0],

        [99.5,0.5 ,0   ,1] => [99 ,0  ,1  ,1],
        [99.7,0.3 ,0   ,1] => [99 ,0  ,1  ,1],
        [0.5 ,99.5,0   ,1] => [0  ,99 ,1  ,1],
        [99.4,0.4 ,0.2 ,1] => [99 ,0  ,1  ,1],
        [98.6,0.7 ,0.7 ,1] => [98 ,0  ,2  ,1],
        [33.3,33.3,33.3,1] => [33 ,33 ,34 ,1],
        [33.4,33.3,33.2,1] => [33 ,33 ,34 ,1],
        [99  ,0.5 , 0.5,1] => [99 ,0  ,1  ,1],
        [67  ,32  ,1   ,1] => [67 ,32 ,1  ,1],
        [67  ,33  ,0   ,1] => [67 ,33 ,0  ,1],
        [67  ,32.5,0.5 ,1] => [67 ,32 ,1  ,1]

       }.each do |percentages_in, percentages_out|
         it "should format (#{percentages_in}) as #{percentages_out}" do
             opinion_in = mock believes: percentages_in[0]/100.0,
                            disbelieves: percentages_in[1]/100.0,
                                 doubts: percentages_in[2]/100.0,
                              authority: percentages_in[3]
             result_percentages = OpinionPresenter.new(opinion_in).as_percentages_hash

             result = [
               result_percentages[:believe][:percentage],
               result_percentages[:disbelieve][:percentage],
               result_percentages[:doubt][:percentage],
               result_percentages[:authority]
             ]
             expect(result).to eq(percentages_out)
         end
       end
    end
  end
end
