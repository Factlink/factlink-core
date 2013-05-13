require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/evidence/for_fact_id.rb'

describe Interactors::Evidence::ForFactId do
  include PavlovSupport

  describe '.validate' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'requires fact_id to be an integer' do
      expect_validating('a', :weakening).
        to fail_validation('fact_id should be an integer string.')
    end

    it 'requires fact_id not to be nil' do
      expect_validating(nil, :weakening).
        to fail_validation('fact_id should be an integer string.')
    end

    it 'requires type be :weakening or :supporting' do
      expect_validating('1', :bla).
        to fail_validation('type should be on of these values: [:weakening, :supporting].')
    end
  end

  describe '.authorized?' do
    it 'should check if the fact can be shown' do
      fact_id = '1'
      fact = mock
      
      stub_classes 'Fact'
      Fact.stub(:[]).with(fact_id).and_return(fact)

      ability = mock
      ability.should_receive(:can?).with(:show, fact).and_return(false)

      expect do
        interactor = described_class.new fact_id, :supporting, ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.execute' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'correctly' do
      fact_id = '1'
      type = :supporting
      result = mock
      options = {current_user: mock}

      interactor = Interactors::Evidence::ForFactId.new '1', type, current_user: options

      interactor.should_receive(:query).with(:'evidence/for_fact_id', fact_id, type).and_return(mock)

      result = interactor.execute

      expect(result).to eq result
    end
  end
end
