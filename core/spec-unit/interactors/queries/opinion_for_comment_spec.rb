require 'pavlov_helper'
require_relative '../../../app/interactors/queries/opinion_for_comment.rb'


describe Queries::OpinionForComment do
  include PavlovSupport

  it 'initializes correctly' do
    user = mock()
    interactor = Queries::OpinionForComment.new '1', mock(), current_user: user
    interactor.should_not be_nil
  end

  it 'without current user gives an unauthorized exception' do
    expect { Queries::OpinionForComment.new '1', mock()}.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  it 'with a invalid comment_id doesn''t validate' do
    expect { Queries::OpinionForComment.new 'g', mock()}.
      to raise_error(Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end
end
