require 'pavlov_helper'
require_relative '../../../app/interactors/commands/delete_comment.rb'

describe Commands::DeleteComment do
  include PavlovSupport

  it 'should initialize correctly' do
    command = described_class.new comment_id: '1a', user_id: '2a'
    command.should_not be_nil
  end

  it 'when supplied with a invalid comment id should not validate' do
    command = described_class.new comment_id: 'g6', user_id: 3
    expect { command.call }
      .to raise_error(Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end

  it 'when supplied with a invalid user id should not validate' do
    command = described_class.new comment_id: '1a', user_id: 'g6'
    expect { command.call }
      .to raise_error(Pavlov::ValidationError, 'user_id should be an hexadecimal string.')
  end

  describe '#call' do
    before do
      stub_const 'Comment', Class.new
      stub_const 'User', Class.new
    end

    it 'correctly' do
      user = stub(:user, id: '9a')
      comment = stub(id: '1a', created_by_id: user.id, deletable?: true)
      interactor = described_class.new comment_id: comment.id, user_id: user.id

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

      command = described_class.new comment_id: comment_id, user_id: user_id

      command.should_receive(:old_query).with(:"comments/can_destroy", comment_id, user_id).
        and_return(true)

      command.authorized_in_execute
    end
  end
end
