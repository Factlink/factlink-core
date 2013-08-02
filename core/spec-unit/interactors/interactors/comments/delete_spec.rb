require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/comments/delete.rb'

describe Interactors::Comments::Delete do
  include PavlovSupport

  describe 'validations' do
    it 'requires a valid comment_id' do
      expect_validating( comment_id: 'g6')
        .to fail_validation 'comment_id should be an hexadecimal string.'
    end

    it 'requires an authorized user' do
      expect_validating( comment_id: 'a', pavlov_options: { current_user: nil })
        .to raise_error( Pavlov::AccessDenied, 'Unauthorized')
    end
  end

  describe '#call' do
    it 'correctly' do
      comment_id = 'a12f'
      user = double(id: 1)
      interactor = described_class.new comment_id: comment_id,
        pavlov_options: { current_user: user }

      interactor.should_receive(:old_command).with(:delete_comment, comment_id, user.id.to_s)

      interactor.call
    end
  end
end
