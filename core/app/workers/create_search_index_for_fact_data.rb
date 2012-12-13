class CreateSearchIndexForFactData

  @queue = :search_index_operations

  def self.perform(fact_data_id)
    fact_data = FactData.find(fact_data_id)

    if fact_data
      Commands::ElasticSearchIndexFactDataForTextSearch.new(fact_data).execute
    else
      raise "Failed adding index for fact_data with fact_data_id: #{fact_data_id}"
    end
  end

end
