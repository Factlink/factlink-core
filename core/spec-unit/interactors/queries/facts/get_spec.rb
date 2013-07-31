require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/get.rb'

describe Queries::Facts::Get do
  include PavlovSupport

  it '.new' do
    interactor = Queries::Facts::Get.new '1'
    interactor.should_not be_nil
  end

  describe '.validate' do
    it 'requires fact_id to be an integer' do
      expect_validating('a').
        to fail_validation('id should be an integer string.')
    end
  end

  describe '.execute' do
    before do
      stub_const('Fact',Class.new)
    end

    it 'correctly' do
      fact_id = '1'
      fact = double

      interactor = Queries::Facts::Get.new '1'

      Fact.should_receive(:[]).with(fact_id).and_return(fact)

      result = interactor.execute

      expect(result).to eq fact
    end
  end
end
