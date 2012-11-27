require 'pavlov_helper'
require_relative '../../../app/interactors/commands/delete_comment.rb'

describe Commands::DeleteComment do
  it 'should initialize correctly' do
    command = Commands::DeleteComment.new '1a', '2a'
    command.should_not be_nil
  end

  it 'when supplied with a invalid comment id should not validate' do
    expect { Commands::DeleteComment.new 'g6', 3}.
      to raise_error(Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end

  it 'when supplied with a invalid user id should not validate' do
    expect { Commands::DeleteComment.new '1a', 'g6'}.
      to raise_error(Pavlov::ValidationError, 'user_id should be an hexadecimal string.')
  end

  describe '.execute' do
    before do
      stub_const 'Comment', Class.new
      stub_const 'User', Class.new
    end

    it 'correctly' do
      comment_id = '1a'
      user_id = '9a'
      user = stub(:user, id: user_id)
      comment = stub(created_by_id: user_id)
      interactor = Commands::DeleteComment.new comment_id, user_id

      Comment.should_receive(:find).with(comment_id).and_return(comment)
      User.should_receive(:find).with(user_id).and_return(user)
      comment.should_receive(:delete)

      interactor.execute
    end

    pending "fails when the user is not the owner"
  end
end
