require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/index_for_fact_relation'

describe Interactors::SubComments::IndexForFactRelation do
  include PavlovSupport

  before do
    stub_classes 'SubComment', 'FactRelation', 'KillObject',
      'Queries::SubComments::Index'
  end

  describe 'authorization' do
    it 'checks if the fact relation can be shown' do
      fact_relation_id = 1
      fact_relation = double

      ability = double
      ability.should_receive(:can?).with(:show, fact_relation).and_return(false)
      interactor = described_class.new(fact_relation_id: fact_relation_id,
        pavlov_options: { ability: ability })

      FactRelation.stub(:[]).with(fact_relation_id).and_return(fact_relation)

      expect do
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe 'validations' do
    it 'without fact_relation_id doesn''t validate' do
      expect_validating(fact_relation_id: nil).
        to fail_validation('fact_relation_id should be an integer.')
    end
  end

  describe '#call' do
    it do
      fact_relation = double
      fact_relation_id = 1
      user = double
      dead_sub_comments = double
      options = {ability: double(can?: true)}
      interactor = described_class.new(fact_relation_id: fact_relation_id,
        pavlov_options: options)


      FactRelation.stub(:[]).with(fact_relation_id)
                  .and_return fact_relation
      Pavlov.should_receive(:query)
            .with(:'sub_comments/index',
                      parent_ids_in: fact_relation_id, parent_class: 'FactRelation',
                      pavlov_options: options)
            .and_return(dead_sub_comments)

      expect( interactor.call ).to eq dead_sub_comments
    end


    it 'throws an error when the fact relation does not exist' do
      options = {ability: double(can?: true)}
      interactor = described_class.new(fact_relation_id: 1,
        pavlov_options: options)

      FactRelation.stub(:[]).with(1)
                  .and_return nil

      expect do
        interactor.call
      end.to raise_error(Pavlov::ValidationError, 'fact relation does not exist any more')
    end
  end
end
