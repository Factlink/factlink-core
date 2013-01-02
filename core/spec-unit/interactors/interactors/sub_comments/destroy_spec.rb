require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/destroy'

describe Interactors::SubComments::Destroy do
  include PavlovSupport

  it 'initializes correctly' do
    Interactors::SubComments::Destroy.new '1', current_user: mock
  end

  describe '.authorized' do
    it 'denied when no user is given' do
      expect{ Interactors::SubComments::Destroy.new '1', current_user: nil }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe 'checks the owner' do
    it 'denied when user given isnt the owner' do
      current_user = mock :user, id: 'a1'
      sub_comment = mock :sub_comment, id: 'a3', created_by_id: 'b3'

      interactor = Interactors::SubComments::Destroy.new sub_comment.id, current_user: current_user
      interactor.should_not_receive(:command)
      interactor.should_receive(:query)
                .with(:'sub_comments/get', sub_comment.id)
                .and_return(sub_comment)
      expect{ interactor.execute }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '.validate' do
    let(:subject_class) { Interactors::SubComments::Destroy }

    it 'without id doesn''t validate' do
      expect_validating(nil, current_user: mock).
        to fail_validation('id should be an hexadecimal string.')
    end
  end

  describe '.execute' do
    it 'should call the command destroy' do
      id = '1'

      interactor = Interactors::SubComments::Destroy.new id, current_user: mock
      interactor.should_receive(:command)
                .with(:'sub_comments/destroy', id)
      interactor.stub i_own_sub_comment: true
      interactor.execute
    end
  end

end
