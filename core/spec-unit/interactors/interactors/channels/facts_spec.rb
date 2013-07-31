require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/channels/facts.rb'

describe Interactors::Channels::Facts do
  include PavlovSupport

  it '.new' do
    interactor = Interactors::Channels::Facts.new '1', 2, 3, current_user: mock
    interactor.should_not be_nil
  end

  describe '.validate' do
    it 'fact_id must be an integer' do
      expect_validating('a', 2, 3).
        to fail_validation('id should be an integer string.')
    end

    it 'from must be an integer' do
      expect_validating('1', 'a', 0).
        to fail_validation('from should be an integer.')
    end

    it 'from can be blank' do
      expect_validating('1', nil, 0).
        to_not fail_validation('from should be an integer.')
    end

    it 'count must be an integer' do
      expect_validating('1', 1, 'a').
        to fail_validation('count should be an integer.')
    end

    it 'count can be blank' do
      expect_validating('1', 1, nil).
        to_not fail_validation('count should be an integer.')
    end
  end

  it '.authorized raises when not logged in' do
    expect{ Interactors::Channels::Facts.new '1', 2, 3, current_user: nil }.
      to raise_error Pavlov::AccessDenied, "Unauthorized"
  end

  describe '#call' do
    before do
      stub_classes 'Fact', 'Resque', 'CleanChannel'
    end

    it 'correctly' do
      channel_id = '1'
      user = mock id: '1e'
      from = 2
      count = 3
      fact = double
      result = [{item: fact}]
      evidence_count = 10

      pavlov_options = {current_user: user}
      interactor = Interactors::Channels::Facts.new '1', from, count, pavlov_options

      Pavlov.stub(:old_query)
        .with(:'channels/facts', channel_id, from, count, pavlov_options)
        .and_return(result)
      Fact.stub(:invalid).with(fact).and_return(false)

      expect(interactor.execute).to eq result
    end

    it 'has an invalid fact' do
      channel_id = '1'
      user = mock id: '1e'
      from = 2
      count = 3
      fact = double
      result = [{item: fact}]

      pavlov_options = {current_user: user}
      interactor = Interactors::Channels::Facts.new '1', from, count, pavlov_options

      Pavlov.stub(:old_query)
        .with(:'channels/facts', channel_id, from, count, pavlov_options)
        .and_return(result)
      Fact.stub(:invalid).with(fact).and_return(true)

      Resque.should_receive(:enqueue).with(CleanChannel, channel_id)

      expect(interactor.execute).to eq []
    end
  end
end
