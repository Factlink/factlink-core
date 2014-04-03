require 'spec_helper'

describe RecentlyViewedFacts do
  let(:recently_viewed_facts) { RecentlyViewedFacts.by_user_id(10) }

  describe '.add_fact_id' do
    it 'pushes a fact id on the list' do
      fact_data = create :fact_data

      recently_viewed_facts.add_fact_id fact_data.fact_id

      expect(recently_viewed_facts.top(1).map(&:id)).to eq [fact_data.fact_id]
    end
  end

  # All the sleeps below this line, are to make sure our timpstamp based sorting works.
  # This is sorted on milisecond precision, so if we wait 2 miliseconds nothing can go wrong.
  describe '.top' do
    it 'returns "count" facts' do
      fact_data_1 = create :fact_data
      fact_data_2 = create :fact_data

      recently_viewed_facts.add_fact_id fact_data_1.fact_id
      sleep 0.002
      recently_viewed_facts.add_fact_id fact_data_2.fact_id

      expect(recently_viewed_facts.top(1).map(&:id)).to eq [fact_data_2.fact_id]
    end

    it 'returns the facts sorted by viewed time' do
      fact_data_1 = create :fact_data
      fact_data_2 = create :fact_data
      fact_data_3 = create :fact_data

      recently_viewed_facts.add_fact_id fact_data_1.fact_id
      sleep 0.002
      recently_viewed_facts.add_fact_id fact_data_2.fact_id
      sleep 0.002
      recently_viewed_facts.add_fact_id fact_data_3.fact_id

      expect(recently_viewed_facts.top(3).map(&:id)).to eq [fact_data_3.fact_id, fact_data_2.fact_id, fact_data_1.fact_id]
    end

    it 'handles viewing a factlink multiple times correctly' do
      fact_data_1 = create :fact_data
      fact_data_2 = create :fact_data

      recently_viewed_facts.add_fact_id fact_data_1.fact_id
      sleep 0.002
      recently_viewed_facts.add_fact_id fact_data_2.fact_id
      sleep 0.002
      recently_viewed_facts.add_fact_id fact_data_1.fact_id

      expect(recently_viewed_facts.top(3).map(&:id)).to eq [fact_data_1.fact_id, fact_data_2.fact_id]
    end
  end

  describe '.truncate' do
    it 'removes factlinks except the last "keep_count" number of factlinks' do
      fact_data_1 = create :fact_data
      fact_data_2 = create :fact_data
      fact_data_3 = create :fact_data
      fact_data_4 = create :fact_data

      recently_viewed_facts.add_fact_id fact_data_1.fact_id
      sleep 0.002
      recently_viewed_facts.add_fact_id fact_data_2.fact_id
      sleep 0.002
      recently_viewed_facts.add_fact_id fact_data_3.fact_id
      sleep 0.002
      recently_viewed_facts.add_fact_id fact_data_4.fact_id

      recently_viewed_facts.truncate 1

      expect(recently_viewed_facts.top(3).map(&:id)).to eq [fact_data_4.fact_id]
    end

  end
end
