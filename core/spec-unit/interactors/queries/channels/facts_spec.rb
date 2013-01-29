require_relative '../../../../app/interactors/queries/channels/facts'
require 'pavlov_helper'

describe Queries::Channels::Facts do
  include PavlovSupport

  it '.new' do
    interactor = Queries::Channels::Facts.new '1', 7, 11
    interactor.should_not be_nil
  end

  describe '.validate' do
    let(:subject_class) { Queries::Channels::Facts }

    it 'requires id to be an integer' do
      expect_validating('a', 7, 10).
        to fail_validation('id should be an integer string.')
    end

    it 'requires from to be an integer' do
      expect_validating('1', 'a', 0).
        to fail_validation('from should be an integer.')
    end

    it 'requires count to be an integer' do
      expect_validating('1', 1, 'a').
        to fail_validation('count should be an integer.')
    end
  end

  describe '.execute' do
    before do
      stub_const('Channel', Class.new)
    end

    it 'correctly' do
      channel_id = '1'
      count = 77
      from = 990
      query = Queries::Channels::Facts.new channel_id, from, count
      sorted_facts = mock
      channel = mock
      sorted_facts_page = mock

      query.should_receive(:query).with(:'channels/get',channel_id).and_return(channel)
      channel.should_receive(:sorted_cached_facts).and_return(sorted_facts)
      sorted_facts.should_receive(:below).with(from, {count: count, reversed: true, withscores: true}).and_return(sorted_facts_page)

      query.execute.should eq sorted_facts_page
    end
  end
end
