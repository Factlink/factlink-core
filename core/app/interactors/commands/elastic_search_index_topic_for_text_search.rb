module Commands
  class ElasticSearchIndexTopicForTextSearch < ElasticSearchIndexForTextSearchCommand
    def define_index
      type 'topic'
      field :title
      field :slug_title
    end
  end
end
