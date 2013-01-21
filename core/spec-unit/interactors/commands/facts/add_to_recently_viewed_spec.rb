require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facts/add_to_recently_viewed.rb'

describe Commands::Facts::AddToRecentlyViewed do
  include PavlovSupport

  describe '.new' do
    it 'should initialize correctly' do
      command = Commands::Facts::AddToRecentlyViewed.new 1, "2e"
      expect(command).not_to be_nil
    end
  end

  describe 'validations' do
    let(:subject_class) { Commands::Facts::AddToRecentlyViewed }
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

    it 'calls RecentlyViewedFacts.push_fact_id' do
      fact_id = 14
      user_id = '20e'
      recently_viewed_facts = mock

      RecentlyViewedFacts.should_receive(:by_user_id).with(user_id).and_return(recently_viewed_facts)

      recently_viewed_facts.should_receive(:push_fact_id).with(fact_id)

      Commands::Facts::AddToRecentlyViewed.new(fact_id, user_id).call
    end
  end
end
