require 'pavlov_helper'
require_relative '../../app/interactors/delete_comment.rb'

describe DeleteComment do
  include PavlovSupport

  it 'initializes correctly' do
    user = mock()
    interactor = DeleteComment.new '1', current_user: user
    interactor.should_not be_nil
  end

  it 'when supplied invalid comment_id doesn''t validate' do
    user = mock()
    expect { DeleteComment.new 'g6', current_user: user }.
      to raise_error( Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end

  it 'when not supplied with a user doesn''t authorize' do
    expect { DeleteComment.new 'a'}.
      to raise_error( Pavlov::AccessDenied, 'Unauthorized')
  end

  describe '.execute' do
    it 'correctly' do
      comment_id = 'a12f'
      user = mock(id: 1)
      interactor = DeleteComment.new comment_id, current_user: user
      interactor.should_receive(:command).with(:delete_command, comment_id, user.id)

      interactor.execute
    end

    it 'correctly' do
      comment_id = 'a12f'
      user = mock(id: 1)
      interactor = DeleteComment.new comment_id, current_user: user
      interactor.should_receive(:command).with(:delete_command, comment_id, user.id)

      interactor.execute
    end
  end
end
