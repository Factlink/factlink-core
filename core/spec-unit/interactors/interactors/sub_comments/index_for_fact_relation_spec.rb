require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/index_for_fact_relation'

describe Interactors::SubComments::IndexForFactRelation do
  include PavlovSupport
  before do
    stub_classes 'SubComment', 'FactRelation', 'KillObject',
                 'Queries::SubComments::Index'
  end

  describe '#authorized' do
    it 'checks if the fact relation can be shown' do
      fact_relation_id = 1
      fact_relation = mock

      FactRelation.stub(:[]).with(fact_relation_id).and_return(fact_relation)

      ability = mock
      ability.should_receive(:can?).with(:show, fact_relation).and_return(false)

      expect do
        interactor = described_class.new fact_relation_id, ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#validate' do
    it 'without fact_relation_id doesn''t validate' do
      expect_validating(nil).
        to fail_validation('fact_relation_id should be an integer.')
    end
  end

  describe '#execute' do

    it do
      fact_relation = mock
      fact_relation_id = 1
      user = mock
      sub_comments = [mock, mock]
      dead_sub_comments = [mock, mock]
      authorities = [10, 20]

      options = {ability: mock(can?: true)}

      FactRelation.stub(:[]).with(fact_relation_id)
                  .and_return fact_relation

      interactor = described_class.new fact_relation_id, options

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

      results = interactor.execute

      expect( results ).to eq dead_sub_comments
    end


    it 'throws an error when the fact relation does not exist' do
      stub_const 'Pavlov::ValidationError', RuntimeError
      options = {ability: mock(can?: true)}

      FactRelation.stub(:[]).with(1)
                  .and_return nil

      interactor = described_class.new 1, options

      expect{interactor.call}.to raise_error(Pavlov::ValidationError, "fact relation does not exist any more")
    end
  end

  describe '#top_fact' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'returns the top fact for the fact_relation_id' do
      fact_relation_id = 1
      fact = mock
      fact_relation = mock(fact: fact)
      FactRelation.should_receive(:[]).with(fact_relation_id).and_return(fact_relation)

      interactor = Interactors::SubComments::IndexForFactRelation.new fact_relation_id

      result = interactor.top_fact

      result.should eq fact
    end

    it 'caches the fact' do
      fact_relation_id = 1
      fact = mock
      fact_relation = mock(fact: fact)
      FactRelation.should_receive(:[]).with(fact_relation_id).and_return(fact_relation)

      interactor = Interactors::SubComments::IndexForFactRelation.new fact_relation_id

      result = interactor.top_fact

      result2 = interactor.top_fact

      result2.should eq fact
    end
  end

  describe '#authority_of_user_who_created' do
    before do
      stub_classes 'Queries::AuthorityOnFactFor'
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'retrieves the authority and kills the subcomment' do
      fact_relation_id = 1
      fact = mock
      graph_user = mock
      authority = mock
      user = mock
      sub_comment = mock(created_by: mock(graph_user: graph_user))
      interactor = Interactors::SubComments::IndexForFactRelation.new fact_relation_id

      interactor.should_receive(:top_fact).and_return(fact)
      interactor.should_receive(:old_query).with(:authority_on_fact_for, fact, graph_user).
        and_return authority

      result = interactor.authority_of_user_who_created sub_comment

      expect(result).to eq authority
    end
  end
end
