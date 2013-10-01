require 'pavlov_helper'
require_relative '../../../app/interactors/commands/delete_comment.rb'

describe Commands::DeleteComment do
  include PavlovSupport

  before do
    stub_classes 'Comment', 'User'
  end

  it 'when supplied with a invalid comment id should not validate' do
    expect_validating(comment_id: 'g6', user_id: 3)
      .to fail_validation 'comment_id should be an hexadecimal string.'
  end

  it 'when supplied with a invalid user id should not validate' do
    expect_validating(comment_id: '1a', user_id: 'g6')
      .to fail_validation 'user_id should be an hexadecimal string.'
  end

  describe '#call' do
    it 'runs correctly when the comment can be removed' do
      user = double(:user, id: '9a')
      comment = double(id: '1a', created_by_id: user.id, deletable?: true)
      interactor = described_class.new comment_id: comment.id, user_id: user.id

      Pavlov.stub(:query)
            .with(:"comments/can_destroy", comment_id: comment.id, user_id: user.id)
            .and_return(true)

      Comment.stub(:find).with(comment.id).and_return(comment)

      comment.should_receive(:delete)

      interactor.call
    end

    it "raises an exception when the comment cannot be removed" do
      comment_id = '10a'
      user_id = '20a'

      command = described_class.new comment_id: comment_id, user_id: user_id

      Pavlov.should_receive(:query)
            .with(:"comments/can_destroy", comment_id: comment_id, user_id: user_id)
            .and_return(false)

      expect do
        command.call
      end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end
  end
end
