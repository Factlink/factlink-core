require 'pavlov_helper'
require_relative '../../../app/interactors/commands/delete_comment.rb'

describe Commands::DeleteComment do
  it 'should initialize correctly' do
    command = Commands::DeleteComment.new '1a', 2
    command.should_not be_nil
  end

  it 'when supplied with a invalid comment id should not validate' do
    expect { Commands::DeleteComment.new 'g6', 3}.
      to raise_error(Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end

  it 'when supplied with a invalid user id should not validate' do
    expect { Commands::DeleteComment.new '1a', 'bla'}.
      to raise_error(Pavlov::ValidationError, 'user_id should be a integer.')
  end

  describe '.execute' do
    before do
      stub_const('Comment', Class.new)
      stub_const('User', Class.new)
    end

    it 'correctly' do
      comment_id = 'a1'
      user_id = 9
      interactor = Commands::DeleteComment.new comment_id, user_id
      user = mock()
      comment = mock(created_by: user)
      Comment.should_receive(:find).with(comment_id).and_return(comment)
      User.should_receive(:find).with(user_id).and_return(user)
      comment.should_receive(:delete)

      interactor.execute
    end
  end
end
