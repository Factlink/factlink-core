require 'pavlov_helper'
require_relative '../../app/interactors/delete_comment_interactor.rb'

describe DeleteCommentInteractor do
  include PavlovSupport

  it 'initializes correctly' do
    user = mock()
    interactor = DeleteCommentInteractor.new '1', current_user: user
    interactor.should_not be_nil
  end

  it 'when supplied invalid comment_id doesn''t validate' do
    user = mock()
    expect { DeleteCommentInteractor.new 'g6', current_user: user }.
      to raise_error( Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end

  it 'when not supplied with a user doesn''t authorize' do
    expect { DeleteCommentInteractor.new 'a'}.
      to raise_error( Pavlov::AccessDenied, 'Unauthorized')
  end

  describe '.execute' do
    it 'correctly' do
      comment_id = 'a12f'
      user = mock(id: 1)
      interactor = DeleteCommentInteractor.new comment_id, current_user: user
      interactor.should_receive(:command).with(:delete_comment, comment_id, user.id.to_s)

      interactor.execute
    end

    it 'correctly' do
      comment_id = 'a12f'
      user = mock(id: 1)
      interactor = DeleteCommentInteractor.new comment_id, current_user: user
      interactor.should_receive(:command).with(:delete_comment, comment_id, user.id.to_s)

      interactor.execute
    end
  end
end
