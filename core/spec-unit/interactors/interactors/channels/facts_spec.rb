require 'pavlov_helper'
require 'active_support/core_ext/object/blank'
require_relative '../../../../app/interactors/interactors/channels/facts.rb'

describe Interactors::Channels::Facts do
  include PavlovSupport

  describe 'validations' do
    it 'fact_id must be an integer' do
      expect_validating(id: 'a', from: 2, count: 3).
        to fail_validation('id should be an integer string.')
    end

    it 'from must be an integer' do
      expect_validating(id: '1', from: 'a', count: 0).
        to fail_validation('from should be an integer.')
    end

    it 'from can be blank' do
      expect_validating(id: '1', from: nil, count: 0).
        to_not fail_validation('from should be an integer.')
    end

    it 'count must be an integer' do
      expect_validating(id: '1', from: 1, count: 'a').
        to fail_validation('count should be an integer.')
    end

    it 'count can be blank' do
      expect_validating(id: '1', from: 1, count: nil).
        to_not fail_validation('count should be an integer.')
    end
  end

  it '.authorized raises when not logged in' do
    expect_validating( id: '1', from: 2, count: 3, pavlov_options: { current_user: nil } )
      .to raise_error Pavlov::AccessDenied, "Unauthorized"
  end

  describe '#call' do
    before do
      stub_classes 'Fact', 'Resque', 'CleanChannel'
    end

    it 'correctly' do
      channel_id = '1'
      user = double id: '1e'
      from = 2
      count = 3
      fact = double
      result = [{item: fact}]
      evidence_count = 10

      pavlov_options = { current_user: user }
      interactor = described_class.new id: '1', from: from, count: count,
        pavlov_options: pavlov_options

      Pavlov.stub(:old_query)
        .with(:'channels/facts', channel_id, from, count, pavlov_options)
        .and_return(result)
      Fact.stub(:invalid).with(fact).and_return(false)

      expect(interactor.execute).to eq result
    end

    it 'has an invalid fact' do
      channel_id = '1'
      user = double id: '1e'
      from = 2
      count = 3
      fact = double
      result = [{item: fact}]

      pavlov_options = { current_user: user }
      interactor = described_class.new id: '1', from: from, count: count,
        pavlov_options: pavlov_options

      Pavlov.stub(:old_query)
        .with(:'channels/facts', channel_id, from, count, pavlov_options)
        .and_return(result)
      Fact.stub(:invalid).with(fact).and_return(true)

      Resque.should_receive(:enqueue).with(CleanChannel, channel_id)

      expect(interactor.execute).to eq []
    end
  end
end
