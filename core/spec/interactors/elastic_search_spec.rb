require 'spec_helper'


describe 'elastic search' do
  before do
    ElasticSearch.stub synchronous: true
    stub_const 'TestClass', Struct.new(:id, :test_field)
  end

  let (:test_query) do
    Class.new Queries::ElasticSearch do
      def define_query
        :test_class
      end
    end
  end

  def insert_and_query text, query
    object = TestClass.new
    object.test_field = text
    object.id = '1'
    Pavlov.command :'text_search/index', object: object, type_name: :test_class, fields: [:test_field]

    query = test_query.new keywords: query, page: 1, row_count: 10
    query.call
  end


  it 'searches for operators' do
    results = insert_and_query 'this is not making sense', 'not'

    expect(results.length).to eq 1
  end

  it 'searches for stop words' do
    results = insert_and_query 'this is the document body', 'the'

    expect(results.length).to eq 1
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

    expect(results.length).to eq 1
  end

  it 'searches for operator for a wildcard match' do
    results = insert_and_query 'noting', 'not'

    expect(results.length).to eq 1
  end

  it 'searches for one letter' do
    results = insert_and_query 'merry christmas', 'm'

    expect(results.length).to eq 1
  end
end
