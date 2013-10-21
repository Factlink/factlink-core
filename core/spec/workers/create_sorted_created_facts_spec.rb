require 'spec_helper'

describe CreateSortedCreatedFacts do
  describe '#perform' do
    it "does nothing when the user has no created facts" do
      graph_user = (create :user).graph_user
      worker = CreateSortedCreatedFacts.new(graph_user.id)
      expect(graph_user.created_facts.count).to eq 0
      expect(graph_user.sorted_created_facts.count).to eq 0

      worker.perform

      expect(graph_user.created_facts.count).to eq 0
      expect(graph_user.sorted_created_facts.count).to eq 0
    end

    it "adds a fact if created facts contains one" do
      graph_user = (create :user).graph_user
      worker = CreateSortedCreatedFacts.new(graph_user.id)

      fact = create :fact, created_by: graph_user
      # reproduce situation as the migration will meet it
      graph_user.sorted_created_facts.key.del

      expect(graph_user.created_facts.count).to eq 1
      expect(graph_user.sorted_created_facts.count).to eq 0

      worker.perform

      expect(graph_user.created_facts.count).to eq 1
      expect(graph_user.sorted_created_facts.count).to eq 1
    end

    it "adds a fact with the correct time" do
      graph_user = (create :user).graph_user
      worker = CreateSortedCreatedFacts.new(graph_user.id)

      fact = create :fact, created_by: graph_user
      # reproduce situation as the migration will meet it
      graph_user.sorted_created_facts.key.del

      expect(graph_user.created_facts.count).to eq 1
      expect(graph_user.sorted_created_facts.count).to eq 0

      worker.perform

      expected_timestamp = (fact.data.created_at.to_time.to_f*1000).to_i.to_f

      expect(graph_user.sorted_created_facts.below('inf', withscores: true))
        .to eq [{score: expected_timestamp, item: fact}]
    end
  end
end
