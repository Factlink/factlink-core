require 'pavlov_helper'
require_relative '../../../../../app/interactors/interactors/comments/delete.rb'

describe Interactors::Comments::Delete do
  include PavlovSupport

  before do
    stub_classes 'Comment'
  end

  describe '#validate' do
    it 'requires a valid comment_id' do
      expect_validating( comment_id: 'g6')
        .to fail_validation 'comment_id should be an hexadecimal string.'
    end
  end

  describe '#authorized?' do
    it 'requires an authorized user' do
      expect do
        comment_id = '123abc'
        comment = double
        ability = double
        pavlov_options = {ability: ability}

        Comment.stub(:find).with(comment_id).and_return(comment)
        ability.stub(:can?).with(:destroy, comment).and_return(false)

        interactor = described_class.new(comment_id: comment_id, pavlov_options: pavlov_options)
        interactor.call
      end.to raise_error( Pavlov::AccessDenied, 'Unauthorized')
    end
  end

  describe '#call' do
    it 'correctly' do
      comment_id = '123abc'
      comment = double
      pavlov_options = { ability: double(can?: true) }
      interactor = described_class.new comment_id: comment_id,
                                       pavlov_options: pavlov_options

      Comment.stub(:find).with(comment_id).and_return(comment)

      comment.should_receive(:destroy)

      interactor.call
    end
  end
end
