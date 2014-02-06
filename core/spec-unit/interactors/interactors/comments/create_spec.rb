require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/comments/create.rb'

describe Interactors::Comments::Create do
  include PavlovSupport

  before do
    stub_classes 'Commands::CreateCommentCommand', 'Fact', 'Comment'
  end

  it 'without current user gives an unauthorized exception' do
    expect do
      interactor = described_class.new( fact_id: 1, type: 'believes', content: 'Hoi!')
      interactor.call
    end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  it 'without content doesn''t validate' do
    expect_validating( fact_id: 1, type: 'believes', content: '' )
    .to fail_validation 'content should not be empty.'
  end

  it 'with a invalid fact_id doesn''t validate' do
    expect_validating( fact_id: 'a', type: 'believes', content: 'Hoi!' )
      .to fail_validation 'fact_id should be an integer.'
  end

  describe '#call' do
    it 'works' do
      fact = double( fact_id: 1 )
      content = 'content'
      user = double(id: '1a', graph_user: double)

      comment = double(:comment, id: double(to_s: '10a'), fact_data: double(fact: fact))
      dead_comment = double
      pavlov_options = {current_user: user}
      interactor = described_class.new fact_id: fact.fact_id, content: content,
                                       pavlov_options: pavlov_options

      Pavlov.should_receive(:command)
            .with(:'comments/create',
                      fact_id: fact.fact_id, content: content,
                      user_id: user.id, pavlov_options: pavlov_options)
            .and_return(comment)
      Pavlov.should_receive(:command)
            .with(:'comments/set_opinion',
                      comment_id: comment.id.to_s, opinion: 'believes',
                      graph_user: user.graph_user, pavlov_options: pavlov_options)
      Pavlov.should_receive(:command)
            .with(:'create_activity',
                      graph_user: user.graph_user, action: :created_comment,
                      subject: comment, object: fact,
                      pavlov_options: pavlov_options)
      Pavlov.stub(:query)
            .with(:'comments/by_ids',
                     ids: comment.id, pavlov_options: pavlov_options)
            .and_return([dead_comment])

      expect(interactor.call).to eq dead_comment
    end
  end
end
