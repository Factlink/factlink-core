require 'pavlov_helper'
require_relative '../../../app/interactors/queries/opinion_for_comment.rb'


describe Queries::OpinionForComment do
  include PavlovSupport

  it 'initializes' do
    Queries::OpinionForComment.new '1', mock
  end


  describe 'validation' do
    let(:subject_class) {Queries::OpinionForComment}
    it 'with a invalid comment_id doesn''t validate' do
      expect_validating('g', mock).
        to fail_validation 'comment_id should be an hexadecimal string.'
    end
  end
end
