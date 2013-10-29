require 'spec_helper'

describe CleanChannel do
  include PavlovSupport

  describe ".perform" do
    let(:user) { create :user }
    let(:channel) { create :channel, created_by: user.graph_user }
    let(:f1) { create :fact }
    let(:f2) { create :fact }
    let(:f3) { create :fact }

    before do
      as(user) do |p|
        [f1, f2, f3].each do |fact|
          p.interactor :'channels/add_fact',
                       fact: fact, channel: channel
        end
      end
    end

    it "should not do anything if no facts were deleted" do
      CleanChannel.perform channel.id
      expect(channel.sorted_cached_facts.count).to eq 3
      expect(channel.sorted_internal_facts.count).to eq 3
    end

    it "should remove deleted facts" do
      f1.delete
      CleanChannel.perform channel.id
      expect(channel.sorted_cached_facts.count).to eq 2
      expect(channel.sorted_internal_facts.count).to eq 2
      expect(channel.facts).to match_array [f2, f3]
    end
  end
end
