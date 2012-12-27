class CreateSearchIndexForFactData
  include Pavlov::Helpers

  @queue = :search_index_operations

  def self.perform(fact_data_id)
    fact_data = FactData.find(fact_data_id)

    if fact_data
      command :elastic_search_index_fact_data_for_text_search, fact_data
    else
      raise "Failed adding index for fact_data with fact_data_id: #{fact_data_id}"
    end
  end

end
