require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/destroy'

describe Interactors::SubComments::Destroy do
  include PavlovSupport

  before do
    stub_classes 'SubComment'
  end

  describe '#authorized?' do
    it 'denied when user has not got destroy permission on the sub_comment' do
      current_user = mock :user, id: 'a1'
      sub_comment = mock :sub_comment, id: 'a3', created_by_id: 'b3'

      ability = mock
      ability.stub(:can?).with(:destroy, sub_comment).and_return(false)
      interactor = described_class.new(id: sub_comment.id,
        pavlov_options: { current_user: current_user, ability: ability })

      SubComment.should_receive(:find).with(sub_comment.id)
                .and_return(sub_comment)

      expect do
        interactor.call
      end.to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe 'validations' do
    it 'without id doesn''t validate' do
      expect_validating(id: nil)
        .to fail_validation('id should be an hexadecimal string.')
    end
  end

  describe '#call' do
    it 'should call the command destroy' do
      id = '1'
      ability = stub can?: true
      interactor = described_class.new(id: id,
        pavlov_options: { current_user: mock, ability: ability })

      SubComment.stub :find
      interactor.should_receive(:old_command)
                .with(:'sub_comments/destroy', id)
      interactor.stub i_own_sub_comment: true

      interactor.call
    end
  end
end
