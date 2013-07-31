require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facts/add_to_recently_viewed.rb'

describe Commands::Facts::AddToRecentlyViewed do
  include PavlovSupport

  describe 'validations' do
    it 'requires arguments' do
      expect_validating('a', '2e').
        to fail_validation('fact_id should be an integer.')
    end

    it 'requires arguments' do
      expect_validating(1, 'qqqq').
        to fail_validation('user_id should be an hexadecimal string.')
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

      Commands::Facts::AddToRecentlyViewed.new(fact_id, user_id).call
    end
  end
end
