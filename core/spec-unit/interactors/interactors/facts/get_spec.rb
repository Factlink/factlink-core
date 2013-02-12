require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/get.rb'

describe Interactors::Facts::Get do
  include PavlovSupport

  it '.new' do
    interactor = Interactors::Facts::Get.new '1', current_user: mock
    interactor.should_not be_nil
  end

  describe '.validate' do
    let(:subject_class) { Interactors::Facts::Get }

    it 'requires fact_id to be an integer' do
      expect_validating('a', :id).
        to fail_validation('id should be an integer string.')
    end
  end

  it '.authorized raises when not logged in' do
    expect{ Interactors::Facts::Get.new '1', current_user: nil }.
      to raise_error Pavlov::AccessDenied, "Unauthorized"
  end

  describe '.execute' do
    it 'correctly' do
      fact_id = '1'
      user = mock id: '1e'

      result = mock
      interactor = Interactors::Facts::Get.new '1', current_user: user

      interactor.should_receive(:command).with(:'facts/add_to_recently_viewed', fact_id.to_i, user.id.to_s)

      interactor.should_receive(:query).with(:'facts/get', fact_id).and_return(mock)

      result = interactor.execute

      expect(result).to eq result
    end
  end
end
