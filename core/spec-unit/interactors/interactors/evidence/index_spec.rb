require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/evidence/index.rb'

describe Interactors::Evidence::Index do
  include PavlovSupport

  it '.new' do
    interactor = Interactors::Evidence::Index.new '1', :weakening, current_user: mock
    interactor.should_not be_nil
  end

  describe '.validate' do
    let(:subject_class) { Interactors::Evidence::Index }

    it 'requires fact_id to be an integer' do
      expect_validating('a', :weakening).
        to fail_validation('fact_id should be an integer string.')
    end

    it 'requires fact_id not to be nil' do
      expect_validating(nil, :weakening).
        to fail_validation('fact_id should be an integer string.')
    end

    it 'requires type be :weakening or :supporting' do
      expect_validating('1', :bla).
        to fail_validation('type should be on of these values: [:weakening, :supporting].')
    end
  end

  it '.authorized raises when not logged in' do
    expect{ Interactors::Evidence::Index.new '1', :weakening, current_user: nil }.
      to raise_error Pavlov::AccessDenied, "Unauthorized"
  end

  describe '.execute' do
    it 'correctly' do
      fact_id = '1'
      type = :supporting
      result = mock
      interactor = Interactors::Evidence::Index.new '1', type, current_user: mock

      interactor.should_receive(:query).with(:'evidence/index', fact_id, type).and_return(mock)

      result = interactor.execute

      expect(result).to eq result
    end
  end
end
