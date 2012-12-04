require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/comments/create.rb'

describe Interactors::Comments::Create do
  include PavlovSupport

  it 'initializes correctly' do
    user = mock()
    interactor = Interactors::Comments::Create.new 1, 'believes', 'Hoi!', current_user: user
    interactor.should_not be_nil
  end

  it 'without current user gives an unauthorized exception' do
    expect { Interactors::Comments::Create.new 1, 'believes', 'Hoi!' }.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  it 'without content doesn''t validate' do
    expect { Interactors::Comments::Create.new 1, 'believes', '' }.
      to raise_error(Pavlov::ValidationError, 'content should not be empty.')
  end

  it 'with a invalid fact_id doesn''t validate' do
    expect { Interactors::Comments::Create.new 'a', 'believes', 'Hoi!' }.
      to raise_error(Pavlov::ValidationError, 'fact_id should be an integer.')
  end

  it 'with a invalid type doesn''t validate' do
    expect { Interactors::Comments::Create.new 1, 'dunno', 'Hoi!' }.
      to raise_error(Pavlov::ValidationError, 'type should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  describe '.execute' do
    before do
      stub_const('Commands::CreateCommentCommand', Class.new)
      stub_const 'Fact', Class.new
    end

    it 'works' do
      fact_id = 1
      fact = mock( fact_id: fact_id )
      type = 'believes'
      content = 'content'
      user = mock(id: '1a')
      authority_string = '1.0'
      opinion = mock()

      interactor = Interactors::Comments::Create.new fact_id, type, content, {current_user: user}
      comment = mock(:comment, id: '10a')

      interactor.should_receive(:command).with(:create_comment,fact_id, type, content, user.id).and_return(comment)

      interactor.should_receive(:query).with(:"comments/add_authority_and_opinion", comment, fact).and_return(comment)

      interactor.should_receive(:create_activity).with(comment)

      Fact.should_receive(:[]).with(fact_id).and_return(fact)

      interactor.execute.should eq comment
    end
  end

  describe '.authority_of' do
    it 'retrieves the authority' do
      fact = mock(id: 3)
      type = 'believes'
      content = 'content'
      comment = mock(:comment, created_by: mock(:user, graph_user: mock()))
      user = mock()
      authority = '2.0'

      interactor = Interactors::Comments::Create.new fact.id, type, content, current_user: user

      interactor.should_receive(:fact).and_return(fact)
      interactor.should_receive(:query).with(:authority_on_fact_for, fact, comment.created_by.graph_user).and_return(authority)

      interactor.authority_of(comment).should eq authority
    end
  end

  describe '.opinion_of' do
    it 'returns the opinion object of a comment' do
      fact_id = 1
      fact = mock( fact_id: fact_id )
      type = 'believes'
      content = 'content'
      opinion = mock()
      comment = mock(:comment, id: '10a')
      user = mock

      interactor = Interactors::Comments::Create.new fact_id, type, content, {current_user: user}

      interactor.should_receive(:fact).and_return(fact)
      interactor.should_receive(:query).with(:opinion_for_comment, comment.id, fact).and_return(opinion)

      interactor.opinion_of comment
    end
  end

  describe '.fact' do
    before do
      stub_classes 'Fact'
    end

    it 'returns the fact' do
      fact = mock(id: 3)
      type = 'believes'
      content = 'content'
      comment = mock()
      user = mock()

      interactor = Interactors::Comments::Create.new fact.id, type, content, current_user: user

      Fact.should_receive(:[]).with(fact.id).and_return(fact)

      interactor.fact.should eq fact
    end
  end

  describe '.create_activity' do
    before do
      stub_const('Comment', Class.new)
    end

    it 'creates an activity' do
      fact_id = 1
      type = 'believes'
      content = 'content'
      graph_user = mock()
      user = mock(id: '1a', graph_user: graph_user)
      interactor = Interactors::Comments::Create.new fact_id, type, content, {current_user: user}
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
