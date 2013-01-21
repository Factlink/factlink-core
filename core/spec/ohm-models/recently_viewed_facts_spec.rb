require 'spec_helper'

describe RecentlyViewedFacts do
  let(:recently_viewed_facts) { RecentlyViewedFacts.by_user_id(10) }

  describe '.push_fact_id' do
    it 'pushes a fact id on the list' do
      fact = create :fact

      recently_viewed_facts.push_fact_id fact.id

      expect(recently_viewed_facts.top_facts 1).to eq [fact]
    end
  end

  describe '.top_facts' do
    it 'returns "count" facts' do
      fact1 = create :fact
      fact2 = create :fact

      recently_viewed_facts.push_fact_id fact1.id
      recently_viewed_facts.push_fact_id fact2.id

      expect(recently_viewed_facts.top_facts 1).to eq [fact2]
    end

    it 'returns the facts sorted by viewed time' do
      fact1 = create :fact
      fact2 = create :fact
      fact3 = create :fact

      recently_viewed_facts.push_fact_id fact1.id
      recently_viewed_facts.push_fact_id fact2.id
      recently_viewed_facts.push_fact_id fact3.id

      expect(recently_viewed_facts.top_facts 3).to eq [fact3, fact2, fact1]
    end

    it 'handles viewing a factlink multiple times correctly' do
      fact1 = create :fact
      fact2 = create :fact

      recently_viewed_facts.push_fact_id fact1.id
      recently_viewed_facts.push_fact_id fact2.id
      recently_viewed_facts.push_fact_id fact1.id

      expect(recently_viewed_facts.top_facts 3).to eq [fact1, fact2]
    end
  end

  describe '.truncate' do
    it 'removes factlinks except the last "keep_count" number of factlinks' do
      fact1 = create :fact
      fact2 = create :fact
      fact3 = create :fact
      fact4 = create :fact

      recently_viewed_facts.push_fact_id fact1.id
      recently_viewed_facts.push_fact_id fact2.id
      recently_viewed_facts.push_fact_id fact3.id
      recently_viewed_facts.push_fact_id fact4.id

      recently_viewed_facts.truncate 1

      expect(recently_viewed_facts.top_facts 3).to eq [fact4]
    end

  end
end
