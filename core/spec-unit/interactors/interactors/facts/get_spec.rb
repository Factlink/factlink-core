require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/get.rb'

describe Interactors::Facts::Get do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '.validate' do
    it 'requires fact_id to be an integer' do
      expect_validating('a').
        to fail_validation('id should be an integer string.')
    end
  end

  describe '.authorized?' do
    it 'should check if the fact can be shown' do
      ability = mock
      ability.should_receive(:can?).with(:show, Fact).and_return(false)

      expect do
        interactor = described_class.new '1', ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.execute' do
    it 'calls a command and query if a user is present' do
      fact_id = '1'
      user = mock id: '1e'
      fact = mock


      options = { current_user: user, ability: mock(can?: true)}

      interactor = described_class.new '1', options

      interactor.should_receive(:command)
                .with(:'facts/add_to_recently_viewed',
                       fact_id.to_i, user.id.to_s)

      interactor.stub(:query)
                .with(:'facts/get', fact_id)
                .and_return(fact)

      expect(interactor.call).to eq fact
    end

    it 'calls just a query if no user is present' do
      fact_id = '1'
      fact = mock

      options = { ability: mock(can?: true)}

      interactor = described_class.new '1', options
      interactor.stub(:query)
                .with(:'facts/get', fact_id)
                .and_return(fact)

      expect(interactor.call).to eq fact
    end
  end
end
