require 'pavlov_helper'
require_relative '../../../../../app/interactors/interactors/sub_comments/index_for_comment'

describe Interactors::SubComments::IndexForComment do
  include PavlovSupport
  before do
    stub_classes 'Comment', 'Queries::SubComments::Index'
  end

  describe '#authorized?' do
    it 'checks if the comment can be shown' do
      comment_id = '1a'
      comment = double
      ability = double
      ability.should_receive(:can?).with(:show, comment).and_return(false)
      interactor = described_class.new(comment_id: comment_id, pavlov_options: { ability: ability })

      Comment.stub(:find).with(comment_id).and_return(comment)

      expect do
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe 'validations' do
    it 'without comment_id doesn''t validate' do
      expect_validating(comment_id: nil)
        .to fail_validation('comment_id should be an hexadecimal string.')
    end
  end

  describe '#call' do
    it do
      comment_id = '2b'
      dead_sub_comments = double
      options = {ability: double(can?: true)}
      interactor = described_class.new(comment_id: comment_id,
                                       pavlov_options: options)

      Comment.stub(:find).with(comment_id)
             .and_return(double)
      Backend::SubComments.should_receive(:index)
                          .with(parent_ids_in: comment_id)
                          .and_return(dead_sub_comments)

      expect( interactor.call ).to eq dead_sub_comments
    end

    it 'throws an error when the comment does not exist' do
      options = {ability: double(can?: true)}

      Comment.stub(:find).with('2b')
             .and_return(nil)

      interactor = described_class.new(comment_id: '2b', pavlov_options: options)

      expect do
        interactor.call
      end.to raise_error(Pavlov::ValidationError, 'comment does not exist any more')
    end
  end
end
