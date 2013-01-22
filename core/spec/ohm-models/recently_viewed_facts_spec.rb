require 'spec_helper'

describe RecentlyViewedFacts do
  let(:recently_viewed_facts) { RecentlyViewedFacts.by_user_id(10) }

  describe '.push_fact_id' do
    it 'pushes a fact id on the list' do
      fact = create :fact

      recently_viewed_facts.push_fact_id fact.id

      expect(recently_viewed_facts.top_facts(1).map(&:id)).to eq [fact.id]
    end
  end

  describe '.top_facts' do
    it 'returns "count" facts' do
      fact1 = create :fact
      fact2 = create :fact

      recently_viewed_facts.push_fact_id fact1.id
      sleep 0.1
      recently_viewed_facts.push_fact_id fact2.id

      expect(recently_viewed_facts.top_facts(1).map(&:id)).to eq [fact2.id]
    end

    it 'returns the facts sorted by viewed time' do
      fact1 = create :fact
      fact2 = create :fact
      fact3 = create :fact

      recently_viewed_facts.push_fact_id fact1.id
      sleep 0.1
      recently_viewed_facts.push_fact_id fact2.id
      sleep 0.1
      recently_viewed_facts.push_fact_id fact3.id

      expect(recently_viewed_facts.top_facts(3).map(&:id)).to eq [fact3.id, fact2.id, fact1.id]
    end

    it 'handles viewing a factlink multiple times correctly' do
      fact1 = create :fact
      fact2 = create :fact

      recently_viewed_facts.push_fact_id fact1.id
      sleep 0.1
      recently_viewed_facts.push_fact_id fact2.id
      sleep 0.1
      recently_viewed_facts.push_fact_id fact1.id

      expect(recently_viewed_facts.top_facts(3).map(&:id)).to eq [fact1.id, fact2.id]
    end
  end

  describe '.truncate' do
    it 'removes factlinks except the last "keep_count" number of factlinks' do
      fact1 = create :fact
      fact2 = create :fact
      fact3 = create :fact
      fact4 = create :fact

      recently_viewed_facts.push_fact_id fact1.id
      sleep 0.1
      recently_viewed_facts.push_fact_id fact2.id
      sleep 0.1
      recently_viewed_facts.push_fact_id fact3.id
      sleep 0.1
      recently_viewed_facts.push_fact_id fact4.id

      recently_viewed_facts.truncate 1

      expect(recently_viewed_facts.top_facts(3).map(&:id)).to eq [fact4.id]
    end

  end
end
