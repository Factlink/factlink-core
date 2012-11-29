require 'pavlov_helper'
require_relative '../../../app/interactors/queries/opinion_for_comment.rb'


describe Queries::OpinionForComment do
  include PavlovSupport

  it 'initializes correctly' do
    interactor = Queries::OpinionForComment.new '1', mock()
    interactor.should_not be_nil
  end

  it 'with a invalid comment_id doesn''t validate' do
    expect { Queries::OpinionForComment.new 'g', mock()}.
      to raise_error(Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end
end
