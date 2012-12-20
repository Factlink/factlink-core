require 'pavlov_helper'
require_relative '../../../app/interactors/commands/delete_comment.rb'

describe Commands::DeleteComment do
  include PavlovSupport

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

      interactor.should_receive(:authorized_in_execute)

      Comment.should_receive(:find).with(comment.id).and_return(comment)
      comment.should_receive(:delete)

      interactor.call
    end
  end

  describe 'authorized?' do
    it "calls the can_destroy query" do
      stub_classes 'Queries::Comments::CanDestroy'

      comment_id = '10a'
      user_id = '20a'

      should_receive_new_with_and_receive_call(Queries::Comments::CanDestroy, comment_id, user_id, {}).
        and_return(true)

      command = Commands::DeleteComment.new comment_id, user_id
      command.authorized_in_execute
    end
  end
end
