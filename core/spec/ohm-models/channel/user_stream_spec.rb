require 'spec_helper'

describe Channel::UserStream do
  include AddFactToChannelSupport

  let(:gu) { create :graph_user }
  subject(:stream) { gu.stream }

  context "initially" do
    it "contains no facts" do
      expect(stream.facts.to_a).to be_empty
    end
  end

  context "after adding one empty channel" do
    it "contains no facts" do
      create :channel, created_by: gu

      expect(stream.facts.to_a).to be_empty
    end
  end

  context "after creating a fact" do
    it "contains no facts" do
      create :fact, created_by: gu

      expect(stream.facts.to_a).to be_empty
    end
  end

  context "after adding channel with one fact" do
    it "contains no facts" do
      ch1 = create(:channel, created_by: gu)
      f1 = create(:fact)
      add_fact_to_channel f1, ch1

      refreshed_stream = GraphUser[gu.id].stream

      expect(stream.facts.to_a).to be_empty
      expect(refreshed_stream.facts.to_a).to be_empty
    end
  end

  describe 'other properties' do
    it 'have proper initial values' do
      expect(stream.is_real_channel?).to be_false
      expect(stream.title).to eq "All"
    end
  end

  describe :topic do
    context "normally" do
      it "should be nil" do
        stream.topic.should be_nil
      end
    end
    context "when the slugtitle is not set" do
      it "should be nil" do
        stream.slug_title = nil
        stream.topic.should be_nil
      end
    end
  end
end
