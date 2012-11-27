require 'pavlov_helper'
require_relative '../../app/interactors/create_comment_for_fact_interactor.rb'

describe CreateCommentForFactInteractor do
  include PavlovSupport

  it 'initializes correctly' do
    user = mock()
    interactor = CreateCommentForFactInteractor.new 1, 'believes', 'Hoi!', current_user: user
    interactor.should_not be_nil
  end

  it 'without current user gives an unauthorized exception' do
    expect { CreateCommentForFactInteractor.new 1, 'believes', 'Hoi!' }.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  it 'without content doesn''t validate' do
    expect { CreateCommentForFactInteractor.new 1, 'believes', '' }.
      to raise_error(Pavlov::ValidationError, 'content should not be empty.')
  end

  it 'with a invalid fact_id doesn''t validate' do
    expect { CreateCommentForFactInteractor.new 'a', 'believes', 'Hoi!' }.
      to raise_error(Pavlov::ValidationError, 'fact_id should be an integer.')
  end

  it 'with a invalid opinion doesn''t validate' do
    expect { CreateCommentForFactInteractor.new 1, 'dunno', 'Hoi!' }.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  describe '.execute' do
    before do
      stub_const('Commands::CreateCommentCommand', Class.new)
    end

    it 'correctly' do
      fact_id = 1
      opinion = 'believes'
      content = 'content'
      user = mock(id: '1a')
      interactor = CreateCommentForFactInteractor.new fact_id, opinion, content, {current_user: user}
      comment = mock()

      interactor.should_receive(:command).with(:create_comment,fact_id, opinion, content, user.id).and_return(comment)
      interactor.should_receive(:create_activity).with(comment)

      interactor.execute.should eq comment
    end
  end

  describe '.create_activity' do
    before do
      stub_const('Comment', Class.new)
    end

    it 'correctly' do
      fact_id = 1
      opinion = 'believes'
      content = 'content'
      graph_user = mock()
      user = mock(id: '1a', graph_user: graph_user)
      interactor = CreateCommentForFactInteractor.new fact_id, opinion, content, {current_user: user}
      returned_comment = mock(id: 1)
      mongoid_comment = mock()
      fact = stub()
      fact_data = stub(fact: fact)
      returned_comment.stub(fact_data: fact_data)

      Comment.should_receive(:find).with(returned_comment.id).and_return(mongoid_comment)
      interactor.should_receive(:command).with(:create_activity,graph_user, :created_comment, mongoid_comment, fact)

      interactor.create_activity returned_comment
    end
  end
end
