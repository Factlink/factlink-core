require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/evidence/for_fact_id.rb'

describe Queries::Evidence::ForFactId do
  include PavlovSupport

  it '.new' do
    interactor = Queries::Evidence::ForFactId.new '1', :weakening, current_user: mock
    interactor.should_not be_nil
  end

  describe '.validate' do
    let(:subject_class) { Queries::Evidence::ForFactId }

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

  describe '.execute' do
    it 'correctly' do
      dead_fact_relations_with_opinion = [mock,mock]
      dead_comments_with_opinion = [mock,mock]
      sorted_result = mock
      interactor = Queries::Evidence::ForFactId.new '1', :weakening, current_user: mock

      interactor.should_receive(:dead_fact_relations_with_opinion).and_return(dead_fact_relations_with_opinion)
      interactor.should_receive(:dead_comments_with_opinion).and_return(dead_comments_with_opinion)
      interactor.should_receive(:sort).with(dead_fact_relations_with_opinion+dead_comments_with_opinion).and_return(sorted_result)

      result = interactor.execute

      expect(result).to eq sorted_result
    end
  end

  describe '.dead_fact_relations_with_opinion' do
    before do
      stub_classes 'KillObject'
    end

    it 'correctly' do
      fact_relation = mock(id: '1', class: 'FactRelation')
      graph_user = mock
      opinion_on = mock
      user = mock(graph_user: graph_user)
      opinion = mock

      dead_fact_relation = mock
      sub_comments_count = 2
      interactor = Queries::Evidence::ForFactId.new '1', :supporting, current_user: user

      interactor.should_receive(:query).with(:'sub_comments/count',fact_relation.id, fact_relation.class).
        and_return(sub_comments_count)
      fact_relation.should_receive(:sub_comments_count=).with(sub_comments_count)
      graph_user.should_receive(:opinion_on).with(fact_relation).and_return(opinion_on)
      fact_relation.should_receive(:get_user_opinion).and_return(opinion)
      interactor.should_receive(:fact_relations).and_return([fact_relation])
      KillObject.should_receive(:fact_relation).with(fact_relation,
        {current_user_opinion:opinion_on,opinion:opinion,evidence_class: 'FactRelation'}).
        and_return(dead_fact_relation)

      result = interactor.dead_fact_relations_with_opinion

      expect(result).to eq [dead_fact_relation]
    end
  end

  describe '.dead_comments_with_opinion' do
    it 'correctly' do
      comment = mock(id: '2a', class: 'Comment')
      fact = mock
      dead_comment = mock

      sub_comments_count = 2
      interactor = Queries::Evidence::ForFactId.new '1', :supporting, current_user: mock

      interactor.should_receive(:query).with(:'sub_comments/count',comment.id, comment.class).
        and_return(sub_comments_count)
      comment.should_receive(:sub_comments_count=).with(sub_comments_count)
      interactor.should_receive(:comments).and_return([comment])
      interactor.should_receive(:fact).and_return(fact)
      interactor.should_receive(:query).with(:'comments/add_authority_and_opinion_and_can_destroy', comment, fact).
        and_return(dead_comment)

      dead_comment.should_receive(:evidence_class=).with('Comment')

      result = interactor.dead_comments_with_opinion

      expect(result).to eq [dead_comment]
    end
  end

  describe '.comments' do
    before do
      stub_classes 'Comment'
    end

    it 'retrieves the array of comments' do
      fact = mock(data_id: '10')
      comments = [mock]

      interactor = Queries::Evidence::ForFactId.new '1', :supporting, current_user: mock

      interactor.should_receive(:fact).and_return(fact)
      Comment.should_receive(:where).with(fact_data_id: fact.data_id, type: 'believes').
        and_return comments

      results = interactor.comments

      expect(results).to eq comments
    end
  end

  describe '.fact_relations' do
    it 'returns a list of fact relations' do
      fact_relations = [mock]
      fact = mock
      type = :supporting

      interactor = Queries::Evidence::ForFactId.new '1', type, current_user: mock

      interactor.should_receive(:fact).and_return(fact)
      fact.should_receive(:evidence).with(type).and_return(fact_relations)

      results = interactor.fact_relations

      expect(results).to eq fact_relations
    end
  end
end
