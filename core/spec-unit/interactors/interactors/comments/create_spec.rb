require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/comments/create.rb'

describe Interactors::Comments::Create do
  include PavlovSupport

  before do
    stub_classes 'Commands::CreateCommentCommand', 'Fact', 'Comment'
  end

  it 'without current user gives an unauthorized exception' do
    expect_validating( fact_id: 1, type: 'believes', content: 'Hoi!')
      .to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  it 'without content doesn''t validate' do
    expect_validating( fact_id: 1, type: 'believes', content: '' )
    .to fail_validation 'content should not be empty.'
  end

  it 'with a invalid fact_id doesn''t validate' do
    expect_validating( fact_id: 'a', type: 'believes', content: 'Hoi!' )
      .to fail_validation 'fact_id should be an integer.'
  end

  it 'with a invalid type doesn''t validate' do
    expect_validating( fact_id: 1, type: 'dunno', content: 'Hoi!' )
      .to fail_validation 'type should be on of these values: ["believes", "disbelieves", "doubts"].'
  end

  describe '.call' do
    it 'works' do
      fact = mock( fact_id: 1 )
      type = 'believes'
      content = 'content'
      user = mock(id: '1a', graph_user: mock)

      opinion = mock
      comment = mock(:comment, id: mock(to_s: '10a'), fact_data: mock(fact: fact))
      mongoid_comment = mock
      pavlov_options = {current_user: user}
      interactor = described_class.new fact_id: fact.fact_id, type: type,
                                       content: content,
                                       pavlov_options: pavlov_options

      Pavlov.stub(:old_query)
        .with(:"comments/add_authority_and_opinion_and_can_destroy", comment, fact, pavlov_options)
        .and_return(comment)
      Fact.stub(:[]).with(fact.fact_id).and_return(fact)
      Comment.stub(:find).with(comment.id).and_return(mongoid_comment)

      Pavlov.should_receive(:old_command)
        .with(:create_comment, fact.fact_id, type, content, user.id, pavlov_options)
        .and_return(comment)
      Pavlov.should_receive(:old_command)
        .with(:'comments/set_opinion',comment.id.to_s, 'believes', user.graph_user, pavlov_options)
      Pavlov.should_receive(:old_command)
        .with(:'opinions/recalculate_comment_user_opinion', comment, pavlov_options)
      Pavlov.should_receive(:old_command)
        .with(:create_activity, user.graph_user, :created_comment, mongoid_comment, fact, pavlov_options)

      expect(interactor.call).to eq comment
    end
  end
end
