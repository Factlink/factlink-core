require 'pavlov_helper'
require_relative '../../app/interactors/create_comment_for_fact.rb'

describe CreateCommentForFact do
  include PavlovSupport

  it 'initializes correctly' do
    user = mock()
    interactor = CreateCommentForFact.new 1, 'believes', 'Hoi!', current_user: user
    interactor.should_not be_nil
  end

  it 'without current user gives an unauthorized exception' do
    expect { CreateCommentForFact.new 1, 'believes', 'Hoi!' }.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  it 'without content doesn''t validate' do
    expect { CreateCommentForFact.new 1, 'believes', '' }.
      to raise_error(Pavlov::ValidationError, 'content should not be empty.')
  end

  it 'with a invalid fact_id doesn''t validate' do
    expect { CreateCommentForFact.new 'a', 'believes', 'Hoi!' }.
      to raise_error(Pavlov::ValidationError, 'fact_id should be a integer.')
  end

  it 'with a invalid opinion doesn''t validate' do
    expect { CreateCommentForFact.new 1, 'dunno', 'Hoi!' }.
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
      user = mock(id: 1)
      interactor = CreateCommentForFact.new fact_id, opinion, content, {current_user: user}
      interactor.should_receive(:command).with(:create_comment,fact_id, opinion, content, user.id)

      interactor.execute
    end
  end
end
