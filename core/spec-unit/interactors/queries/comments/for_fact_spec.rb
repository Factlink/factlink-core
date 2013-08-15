require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/comments/for_fact.rb'

describe Queries::Comments::ForFact do
  include PavlovSupport

  before do
    stub_classes 'Comment', 'KillObject', 'Fact', 'OpinionType'
  end

  describe '#call' do
    it 'correctly' do
      comment = double(id: '2a', class: 'Comment')
      fact = double(data_id: '10')
      dead_comment = double
      sub_comments_count = 2
      pavlov_options = { current_user: double }
      type = :supporting
      query = described_class.new fact: fact, type: type, pavlov_options: pavlov_options

      OpinionType.stub(:for_relation_type)
                 .with(type)
                 .and_return(:believes)
      Comment.should_receive(:where)
             .with(fact_data_id: fact.data_id, type: 'believes')
             .and_return [comment]
      Pavlov.should_receive(:query)
            .with(:'sub_comments/count',
                      parent_id: comment.id, parent_class: comment.class,
                      pavlov_options: pavlov_options)
            .and_return(sub_comments_count)
      Pavlov.should_receive(:query)
            .with(:'comments/add_authority_and_opinion_and_can_destroy',
                      comment: comment, fact: fact, pavlov_options: pavlov_options)
            .and_return(dead_comment)

      dead_comment.should_receive(:evidence_class=).with('Comment')
      comment.should_receive(:sub_comments_count=).with(sub_comments_count)

      expect(query.call).to eq [dead_comment]
    end
  end
end
