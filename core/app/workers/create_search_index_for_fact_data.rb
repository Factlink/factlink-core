require 'pavlov'

class CreateSearchIndexForFactData

  @queue = :search_index_operations

  def self.perform(fact_data_id)
    fact_data = FactData.find(fact_data_id)

    if fact_data
      Pavlov.command :'text_search/index_fact_data', fact_data: fact_data
    else
      raise "Failed adding index for fact_data with fact_data_id: #{fact_data_id}"
    end
  end
end
