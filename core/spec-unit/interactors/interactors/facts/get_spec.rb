require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/get.rb'

describe Interactors::Facts::Get do
  include PavlovSupport

  describe '.validate' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'requires fact_id to be an integer' do
      expect_validating('a', :id).
        to fail_validation('id should be an integer string.')
    end
  end

  describe '.authorized?' do
    it 'should check if the fact can be shown' do
      stub_classes 'Fact'

      ability = mock
      ability.should_receive(:can?).with(:show, Fact).and_return(false)

      expect do
        interactor = described_class.new '1', ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.execute' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'calls a command and query if a user is present' do
      fact_id = '1'
      user = mock id: '1e'
      fact = mock

      interactor = described_class.new '1', current_user: user

      interactor.should_receive(:command).with(:'facts/add_to_recently_viewed', fact_id.to_i, user.id.to_s)

      interactor.should_receive(:query).with(:'facts/get', fact_id).and_return(fact)

      result = interactor.execute

      expect(result).to eq fact
    end

    it 'calls just a query if no user is present' do
      fact_id = '1'
      fact = mock

      interactor = described_class.new '1'

      interactor.should_receive(:query).with(:'facts/get', fact_id).and_return(fact)

      result = interactor.execute

      expect(result).to eq fact
    end
  end
end
