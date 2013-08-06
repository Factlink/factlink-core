require 'spec_helper'

class TestClass
  attr_accessor :test_field, :id
end

describe 'elastic search' do
  before do
    ElasticSearch.stub synchronous: true
  end

  let (:test_query) do
    Class.new Queries::ElasticSearch do
      def define_query
        :test_class
      end
    end
  end

  let (:test_index_command) do
    Class.new Commands::ElasticSearchIndexForTextSearch do
      def execute
        field :test_field
        super
      end

      def type_name
        :test_class
      end
    end
  end

  it 'searches for operators' do
    results = insert_and_query 'this is not making sense', 'not'

    results.length.should eq 1
  end

  it 'searches for stop words' do
    results = insert_and_query 'this is the document body', 'the'

    results.length.should eq 1
  end

  it 'searches for sequences that need to be escaped doesn''t throw an error' do
    insert_and_query 'document body', '!(){}[]^"~*?:\\'
  end

  it 'searches for sequences that need to be escaped doesn''t throw an error' do
    insert_and_query 'document body', 'AND OR NOT'
  end

  it 'searches for sequences that need to be escaped doesn''t throw an error' do
    insert_and_query 'document body', 'harrie && klaas || henk'
  end

  it 'searches for wildcards correctly' do
    results = insert_and_query 'merry christmas', 'mer*'

    results.length.should eq 1
  end

  it 'searches for operator for a wildcard match' do
    results = insert_and_query 'noting', 'not'

    results.length.should eq 1
  end

  it 'searches for one letter' do
    results = insert_and_query 'merry christmas', 'm'

    results.length.should eq 1
  end

  def insert_and_query text, query
    object = TestClass.new
    object.test_field = text
    object.id = '1'
    test_index_command.new(object: object).call

    (test_query.new keywords: query, page: 1, row_count: 10).call
  end
end
