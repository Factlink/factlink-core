require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/create_for_fact_relation'

describe Interactors::SubComments::CreateForFactRelation do
  include PavlovSupport

  before do
    stub_classes 'FactRelation', 'SubComment'
  end

  it '#authorized? denied when the user isn not allowed to see the fact_relation' do
    fact_relation = double
    ability = double
    ability.stub(:can?).with(:show, fact_relation).and_return(false)
    interactor = described_class.new(fact_relation_id: 1, content: 'hoi',
      pavlov_options: { current_user: nil, ability: ability})
    FactRelation.should_receive(:[]).and_return(fact_relation)

    expect do
      interactor.call
    end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  describe 'validations' do
    it 'without fact_relation_id doesn''t validate' do
      expect_validating(fact_relation_id: nil, content: 'hoi').
        to fail_validation('fact_relation_id should be an integer.')
    end

    it 'without content doesn''t validate' do
      expect_validating(fact_relation_id: 1, content: '').
        to fail_validation('content should not be empty.')
    end

    it 'without content doesn''t validate' do
      expect_validating(fact_relation_id: 1, content: '  ').
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
      ability = double
      ability.stub(:can?).with(:show, fact_relation).and_return(true)
      ability.stub(:can?).with(:create, SubComment).and_return(true)
      options = { current_user: user, ability: ability }
      interactor = described_class.new(fact_relation_id: fact_relation_id,
        content: content, pavlov_options: options)

      FactRelation.stub :[] => fact_relation
      Pavlov.should_receive(:command)
            .with(:'sub_comments/create_xxx',
                      parent_id: fact_relation_id, parent_class: 'FactRelation',
                      content: content, user: user, pavlov_options: options)
            .and_return(sub_comment)
      interactor.should_receive(:authority_of_user_who_created).with(sub_comment).
        and_return(authority)
      interactor.should_receive(:create_activity).with(sub_comment)
      KillObject.should_receive(:sub_comment).with(sub_comment, authority: authority).
        and_return(dead_sub_comment)

      expect(interactor.call).to eq dead_sub_comment
    end

    it 'throws an error when the fact relation does not exist' do
      ability = double can?: true
      interactor = described_class.new(fact_relation_id: 1, content: 'content',
        pavlov_options: { current_user: double, ability: ability })

      FactRelation.stub :[] => nil

      expect do
        interactor.call
      end.to raise_error(Pavlov::ValidationError, 'parent does not exist any more')
    end
  end

  describe '#top_fact' do
    it 'returns the top fact for the fact_relation_id' do
      fact = double
      fact_relation = double(id: 1, fact: fact)
      ability = double(can?: true)
      options = { current_user: double, ability: ability }
      interactor = described_class.new(fact_relation_id: fact_relation.id,
        content: 'hoi', pavlov_options: options)

      FactRelation.should_receive(:[])
        .with(fact_relation.id)
        .and_return(fact_relation)

      expect(interactor.top_fact).to eq fact
    end

    it 'caches the fact' do
      fact = double
      fact_relation = double(id: 1, fact: fact)
      ability = double(can?: true)
      options = { current_user: double, ability: ability }
      interactor = described_class.new(fact_relation_id: fact_relation.id,
        content: 'hoi', pavlov_options: options)

      FactRelation.should_receive(:[]).with(fact_relation.id).and_return(fact_relation)

      interactor.top_fact
      next_result = interactor.top_fact

      next_result.should eq fact
    end
  end

  describe '#authority_of_user_who_created' do
    before do
      stub_classes 'Queries::AuthorityOnFactFor'
    end

    it 'retrieves the authority and kills the subcomment' do
      fact_relation_id = 1
      fact = double
      graph_user = double
      authority = double
      user = double
      sub_comment = double(created_by: double(graph_user: graph_user))
      FactRelation.stub :[] => nil
      ability = double can?: true
      options = { current_user: user, ability: ability }
      interactor = described_class.new(fact_relation_id: fact_relation_id,
        content: 'hoi', pavlov_options: options)

      interactor.should_receive(:top_fact).and_return(fact)
      Pavlov.should_receive(:query)
            .with(:'authority_on_fact_for',
                      fact: fact, graph_user: graph_user, pavlov_options: options)
            .and_return authority

      result = interactor.authority_of_user_who_created sub_comment

      expect(result).to eq authority
    end
  end
end
