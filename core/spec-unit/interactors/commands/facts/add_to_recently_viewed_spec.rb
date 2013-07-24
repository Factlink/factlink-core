require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facts/add_to_recently_viewed.rb'

describe Commands::Facts::AddToRecentlyViewed do
  include PavlovSupport

  describe '.new' do
    it 'should initialize correctly' do
      command = described_class.new fact_id: 1, user_id: "2e"
      expect(command).not_to be_nil
    end
  end

  describe 'validations' do
    it 'requires arguments' do
      expect_validating(fact_id: 'a', user_id: '2e')
        .to fail_validation('fact_id should be an integer.')
    end

    it 'requires arguments' do
      expect_validating(fact_id: 1, user_id: 'qqqq')
        .to fail_validation('user_id should be an hexadecimal string.')
    end
  end

  describe '.call' do
    before do
      stub_classes 'RecentlyViewedFacts'
    end

    it 'calls RecentlyViewedFacts.add_fact_id' do
      fact_id = 14
      user_id = '20e'
      recently_viewed_facts = mock

      RecentlyViewedFacts.should_receive(:by_user_id).with(user_id).and_return(recently_viewed_facts)

      recently_viewed_facts.should_receive(:add_fact_id).with(fact_id)

      command = described_class.new fact_id: fact_id, user_id: user_id
      command.call
    end
  end
end
