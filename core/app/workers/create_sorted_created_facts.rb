class CreateSortedCreatedFacts
  @queue = :migration

  def initialize graph_user_id
    @graph_user_id = graph_user_id
  end

  def perform
    graph_user.created_facts.each do |fact|
      graph_user.sorted_created_facts.add fact, timestamp_for(fact)
    end
  end

  def graph_user
    @graph_user ||= GraphUser[@graph_user_id]
  end

  def timestamp_for fact
    (fact.data.created_at.to_time.to_f*1000).to_i
  end

  def self.perform *args
    new(*args).perform
  end
end
