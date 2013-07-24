require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/evidence/for_fact_id.rb'

describe Interactors::Evidence::ForFactId do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe 'validation' do
    it 'requires fact_id to be an integer' do
      expect_validating(fact_id: 'a', type: :weakening).
        to fail_validation('fact_id should be an integer string.')
    end

    it 'requires fact_id not to be nil' do
      expect_validating(fact_id: nil, type: :weakening).
        to fail_validation('fact_id should be an integer string.')
    end

    it 'requires type be :weakening or :supporting' do
      expect_validating(fact_id: '1', type: :bla).
        to fail_validation('type should be on of these values: [:weakening, :supporting].')
    end
  end

  describe '#authorized?' do
    it 'should check if the fact can be shown' do
      ability = mock
      ability.stub(:can?)
             .with(:show, Fact)
             .and_return(false)

      interactor = described_class.new fact_id: '1', type: :supporting,
        pavlov_options: { ability: ability }

      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    it 'correctly' do
      fact_id = '1'
      type = :supporting
      fact = mock
      pavlov_options = { current_user: mock, ability: mock(can?: true) }
      interactor = described_class.new fact_id: fact_id, type: type,
        pavlov_options: pavlov_options

      Pavlov.stub(:old_query)
                .with(:'evidence/for_fact_id', fact_id, type, pavlov_options)
                .and_return(fact)

      expect(interactor.call).to eq fact
    end
  end
end
