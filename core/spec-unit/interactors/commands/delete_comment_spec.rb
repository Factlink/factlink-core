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

  describe '.call' do
    before do
      stub_const 'Comment', Class.new
      stub_const 'User', Class.new
    end

    it 'correctly' do
      user = stub(:user, id: '9a')
      comment = stub(id: '1a', created_by_id: user.id, deletable?: true)
      interactor = Commands::DeleteComment.new comment.id, user.id

      Comment.should_receive(:find).with(comment.id).and_return(comment)
      comment.should_receive(:delete)

      interactor.call
    end

    it "fails when the user is not the owner" do
      user = stub(id: '9a')
      comment = stub(id: '1a', created_by_id: user.id, deletable?: true)
      other_user = stub(id: '100a')

      interactor = Commands::DeleteComment.new comment.id, other_user.id

      Comment.should_receive(:find).with(comment.id).and_return(comment)

      expect{interactor.call}.to raise_error Pavlov::AccessDenied
    end

    it "fails when the comment cannot be deleted" do
      user = stub(id: '9a')
      comment = stub(id: '1a', created_by_id: user.id, deletable?: false)

      interactor = Commands::DeleteComment.new comment.id, user.id

      Comment.should_receive(:find).with(comment.id).and_return(comment)

      expect{interactor.call}.to raise_error Commands::DeleteComment::NotPossibleError
    end
  end
end
