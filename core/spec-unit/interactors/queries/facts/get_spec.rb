require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/get.rb'

describe Queries::Facts::Get do
  include PavlovSupport

  describe 'validation' do
    it 'requires fact_id to be an integer' do
      expect_validating(id: 'a').
        to fail_validation('id should be an integer string.')
    end
  end

  describe '#call' do
    before do
      stub_const('Fact', Class.new)
    end

    it 'correctly' do
      fact_id = '1'
      fact = double
      interactor = Queries::Facts::Get.new id: '1'

      Fact.should_receive(:[]).with(fact_id).and_return(fact)

      result = interactor.call

      expect(result).to eq fact
    end
  end
end
