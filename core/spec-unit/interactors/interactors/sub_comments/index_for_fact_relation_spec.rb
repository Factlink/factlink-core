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
      sub_comments = [mock, mock]
      dead_sub_comments = [mock, mock]
      authorities = [10, 20]
      options = {ability: mock(can?: true)}
      interactor = described_class.new(fact_relation_id: fact_relation_id,
        pavlov_options: options)


      FactRelation.stub(:[]).with(fact_relation_id)
                  .and_return fact_relation
      interactor.should_receive(:old_query).with(:"sub_comments/index", fact_relation_id, 'FactRelation').
        and_return(sub_comments)

      interactor.should_receive(:authority_of_user_who_created).
        with(sub_comments[0]).
        and_return(authorities[0])
      interactor.should_receive(:authority_of_user_who_created).
        with(sub_comments[1]).
        and_return(authorities[1])

      KillObject.should_receive(:sub_comment).
        with(sub_comments[0], authority: authorities[0]).
        and_return(dead_sub_comments[0])
      KillObject.should_receive(:sub_comment).
        with(sub_comments[1], authority: authorities[1]).
        and_return(dead_sub_comments[1])

      expect( interactor.call ).to eq dead_sub_comments
    end


    it 'throws an error when the fact relation does not exist' do
      stub_const 'Pavlov::ValidationError', RuntimeError
      options = {ability: mock(can?: true)}
      interactor = described_class.new(fact_relation_id: 1,
        pavlov_options: options)

      FactRelation.stub(:[]).with(1)
                  .and_return nil

      expect do
        interactor.call
      end.to raise_error(Pavlov::ValidationError, 'fact relation does not exist any more')
    end
  end

  describe '#top_fact' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'returns the top fact for the fact_relation_id' do
      fact_relation_id = 1
      fact = double
      fact_relation = mock(fact: fact)
      interactor = described_class.new(fact_relation_id: fact_relation_id)

      FactRelation.stub(:[]).with(fact_relation_id).and_return(fact_relation)

      expect(interactor.top_fact).to eq fact
    end

    it 'caches the fact' do
      fact_relation_id = 1
      fact = double
      fact_relation = mock(fact: fact)
      interactor = described_class.new(fact_relation_id: fact_relation_id)

      FactRelation.stub(:[]).with(fact_relation_id).and_return(fact_relation)

      interactor.top_fact

      next_result = interactor.top_fact

      expect(next_result).to eq fact
    end
  end

  describe '#authority_of_user_who_created' do
    before do
      stub_classes 'Queries::AuthorityOnFactFor'
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'retrieves the authority and kills the subcomment' do
      fact_relation_id = 1
      fact = double
      graph_user = double
      authority = double
      user = double
      sub_comment = mock(created_by: mock(graph_user: graph_user))
      interactor = described_class.new(fact_relation_id: fact_relation_id)

      interactor.should_receive(:top_fact).and_return(fact)
      interactor.should_receive(:old_query).with(:authority_on_fact_for, fact, graph_user).
        and_return authority

      result = interactor.authority_of_user_who_created sub_comment

      expect(result).to eq authority
    end
  end
end
