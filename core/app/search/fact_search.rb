class FactSearch
  class FactWrapper
    def initialize(attributes={})
      @attributes = attributes
    end

    def type
      'fact_data'
    end

    def to_indexed_json
      @attributes.to_json
    end
  end

  @index = :fact_data
  def self.evidence_for(fact, search_for)
    return [] unless search_for.length > 0

    results = Tire.search @index do
      query { string search_for }
    end.results

    return results.map { |res| Fact[res.id]}.
                  delete_if {|f| f.nil? || (fact && f.id == fact.id)}
  end

  def self.reset_index
    Tire.index @index do
      delete

      create :settings => {
        index: {
          analysis: {
            filter: {
              ngram_filter: {
                type: "nGram",
                min_gram: 3,
                max_gram: 8
              }
            },
            analyzer: {
              ngram_analyzer: {
                tokenizer: "lowercase",
                filter: "ngram_filter",
                type: "custom"
              }
            }
          }
        }
      },
      mappings: {
        'document' => {
          'properties' => {
            'displaystring' => {
              type: 'string',
              analyzer: 'ngram_analyzer'
            }
          }
        }
      }

      FactData.all.each do |fd|
        store displaystring: fd.displaystring, id: fd.fact_id
      end
    end
  end
end