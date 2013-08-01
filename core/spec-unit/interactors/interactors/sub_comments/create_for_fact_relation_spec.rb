require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/create_for_fact_relation'

describe Interactors::SubComments::CreateForFactRelation do
  include PavlovSupport

  before do
    stub_classes 'FactRelation', 'SubComment'
  end

  it '.authorized denied when the user isn not allowed to see the fact_relation' do
    fact_relation = double
    ability = double
    ability.stub(:can?).with(:show, fact_relation).and_return(false)
    FactRelation.should_receive(:[]).and_return(fact_relation)

    expect{ Interactors::SubComments::CreateForFactRelation.new 1, 'hoi', current_user: nil, ability: ability }.
      to raise_error Pavlov::AccessDenied, 'Unauthorized'
  end

  describe '.validate' do
    it 'without fact_relation_id doesn''t validate' do
      expect_validating(nil, 'hoi').
        to fail_validation('fact_relation_id should be an integer.')
    end

    it 'without content doesn''t validate' do
      expect_validating(1, '').
        to fail_validation('content should not be empty.')
    end

    it 'without content doesn''t validate' do
      expect_validating(1, '  ').
        to fail_validation('content should not be empty.')
    end
  end

  describe '#call' do
    before do
      stub_classes 'KillObject', 'Commands::SubComments::CreateXxx'
    end

    it 'calls the corresponding command' do
      fact_relation_id = 1
      user = double
      sub_comment = double
      authority = double
      dead_sub_comment = double
      content = 'hoi'
      fact_relation = double
      FactRelation.stub :[] => fact_relation

      ability = double
      ability.stub(:can?).with(:show, fact_relation).and_return(true)
      ability.stub(:can?).with(:create, SubComment).and_return(true)

      interactor = Interactors::SubComments::CreateForFactRelation.new fact_relation_id, content, current_user: user, ability: ability

      interactor.should_receive(:old_command).with(:"sub_comments/create_xxx", fact_relation_id, 'FactRelation', content, user).
        and_return(sub_comment)
      interactor.should_receive(:authority_of_user_who_created).with(sub_comment).
        and_return(authority)
      interactor.should_receive(:create_activity).with(sub_comment)
      KillObject.should_receive(:sub_comment).with(sub_comment, authority: authority).
        and_return(dead_sub_comment)

      result = interactor.execute

      expect(result).to eq dead_sub_comment
    end

    it 'throws an error when the fact relation does not exist' do
      stub_const 'Pavlov::ValidationError', RuntimeError

      ability = mock can?: true
      FactRelation.stub :[] => nil
      interactor = Interactors::SubComments::CreateForFactRelation.new 1, 'content', current_user: mock, ability: ability

      expect{interactor.call}.to raise_error(Pavlov::ValidationError, "parent does not exist any more")
    end
  end

  describe '.top_fact' do
    it 'returns the top fact for the fact_relation_id' do
      fact = double
      fact_relation = mock id: 1, fact: fact
      FactRelation.should_receive(:[]).with(fact_relation.id).and_return(fact_relation)
      ability = mock can?: true

      interactor = Interactors::SubComments::CreateForFactRelation.new fact_relation.id, 'hoi', current_user: mock, ability: ability

      result = interactor.top_fact

      result.should eq fact
    end

    it 'caches the fact' do
      fact = double
      fact_relation = mock id: 1, fact: fact
      FactRelation.should_receive(:[]).with(fact_relation.id).and_return(fact_relation)

      ability = mock can?: true

      interactor = Interactors::SubComments::CreateForFactRelation.new fact_relation.id, 'hoi', current_user: mock, ability: ability

      result = interactor.top_fact

      result2 = interactor.top_fact

      result2.should eq fact
    end
  end

  describe '.authority_of_user_who_created' do
    before do
      stub_classes 'Queries::AuthorityOnFactFor'
    end

    it 'retrieves the authority and kills the subcomment' do
      fact_relation_id = 1
      fact = double
      graph_user = double
      authority = double
      user = double
      sub_comment = mock(created_by: mock(graph_user: graph_user))
      FactRelation.stub :[] => nil
      ability = mock can?: true
      interactor = Interactors::SubComments::CreateForFactRelation.new fact_relation_id, 'hoi', current_user: user, ability: ability

      interactor.should_receive(:top_fact).and_return(fact)
      interactor.should_receive(:old_query).with(:authority_on_fact_for, fact, graph_user).
        and_return authority

      result = interactor.authority_of_user_who_created sub_comment

      expect(result).to eq authority
    end
  end
end
