require 'pavlov_helper'
require_relative '../../../../app/classes/opinion_type.rb'
require_relative '../../../../app/classes/opinion_presenter.rb'
require_relative '../../../../app/interactors/queries/evidence/for_fact_id.rb'

describe Queries::Evidence::ForFactId do
  include PavlovSupport

  before do
    stub_classes 'Comment', 'KillObject', 'Fact'
  end

  def fake_opinion relevance
    mock authority: relevance,
         beliefs: 1,
         disbeliefs: 0
  end

  describe '.validate' do
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
      dead_fact_relations_with_opinion = [
        mock(:fact_relation1, opinion: fake_opinion(1)),
        mock(:fact_relation2, opinion: fake_opinion(3))
      ]
      dead_comments_with_opinion = [
        mock(:comment1, opinion: fake_opinion(2)),
        mock(:comment2, opinion: fake_opinion(4))
      ]
      sorted_result = [
        dead_comments_with_opinion[1],
        dead_fact_relations_with_opinion[1],
        dead_comments_with_opinion[0],
        dead_fact_relations_with_opinion[0]
      ]
      interactor = Queries::Evidence::ForFactId.new '1', :weakening, current_user: mock

      interactor.should_receive(:dead_fact_relations_with_opinion).and_return(dead_fact_relations_with_opinion)
      interactor.should_receive(:dead_comments_with_opinion).and_return(dead_comments_with_opinion)

      result = interactor.execute

      expect(result).to eq sorted_result
    end
  end

  describe '.dead_fact_relations_with_opinion' do

    it 'returns a dead object' do
      fact = mock id: '1'
      dead_fact_relations = mock
      type = :supporting
      pavlov_options = { current_user: mock }

      Fact.stub(:[]).with(fact.id).and_return(fact)
      Pavlov.stub(:query)
            .with(:'fact_relations/for_fact', fact, type, pavlov_options)
            .and_return dead_fact_relations

      interactor = described_class.new fact.id, type , pavlov_options
      result = interactor.dead_fact_relations_with_opinion

      expect(result).to eq dead_fact_relations
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
end
