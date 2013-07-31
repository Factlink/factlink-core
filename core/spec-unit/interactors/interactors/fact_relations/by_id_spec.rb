require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/fact_relations/by_id.rb'

describe Interactors::FactRelations::ById do
  include PavlovSupport

  before do
    stub_classes 'FactRelation'
  end

  describe '.validate' do
    it 'requires fact_relation_id to be an integer' do
      expect_validating(nil).
        to fail_validation('fact_relation_id should be an integer string.')
    end
  end

  describe '#authorized?' do
    it 'should check if the fact relation can be shown' do
      ability = double
      pavlov_options = { ability: ability }

      ability.stub(:can?)
             .with(:show, FactRelation)
             .and_return(false)

      expect do
        interactor = described_class.new '1', pavlov_options
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    it 'correctly' do
      fact_relation_id = '1'
      fact_relation = double
      pavlov_options = {current_user: double, ability: double(can?: true)}
      interactor = described_class.new fact_relation_id, pavlov_options

      Pavlov.stub(:old_query)
            .with(:'fact_relations/by_ids', [fact_relation_id], pavlov_options)
            .and_return([fact_relation])

      expect(interactor.call).to eq fact_relation
    end
  end
end
