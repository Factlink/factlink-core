require 'pavlov_helper'
require 'active_support/core_ext/object/blank'
require 'nest'
require_relative '../../../../app/interactors/interactors/channels/facts.rb'

describe Interactors::Channels::Facts do
  include PavlovSupport

  before do
    stub_classes 'Fact', 'Channel', 'Resque', 'CleanSortedFacts'
  end

  describe 'validations' do
    it 'fact_id must be an integer' do
      expect_validating(id: 'a', from: 2, count: 3).
        to fail_validation('id should be an integer string.')
    end

    it 'from must be an integer' do
      expect_validating(id: '1', from: 'a', count: 0).
        to fail_validation('from should be an integer.')
    end

    it 'count must be an integer' do
      expect_validating(id: '1', from: 1, count: 'a').
        to fail_validation('count should be an integer.')
    end
  end

  it '.authorized raises when not logged in' do
    expect do
      interactor = described_class.new(id: '1', from: 2, count: 3, pavlov_options: { current_user: nil })
      interactor.call
    end.to raise_error Pavlov::AccessDenied, "Unauthorized"
  end

  describe '#call' do
    it 'correctly' do
      channel_id = '1'
      user = double id: '1e'
      from = 2
      count = 3
      fact = double
      result = [{item: fact}]

      pavlov_options = { current_user: user }
      interactor = described_class.new id: '1', from: from, count: count,
        pavlov_options: pavlov_options

      Pavlov.stub(:query)
            .with(:'channels/facts',
                      id: channel_id, from: from, count: count,
                      pavlov_options: pavlov_options)
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

      Pavlov.stub(:query)
            .with(:'channels/facts',
                      id: channel_id, from: from, count: count,
                      pavlov_options: pavlov_options)
            .and_return(result)
      Fact.stub(:invalid).with(fact).and_return(true)

      Channel.stub(:key)
             .and_return(Nest.new('Channel'))

      expect(Resque)
        .to receive(:enqueue)
        .with(CleanSortedFacts, "Channel:#{channel_id}:sorted_internal_facts")

      expect(interactor.execute).to eq []
    end
  end
end
