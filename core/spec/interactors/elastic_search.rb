require 'spec_helper'

class TestClass
  attr_accessor :test_field, :id
end

class TestIndexCommand < Commands::ElasticSearchIndexForTextSearchCommand
  def define_index
    type 'test_class'
    field :test_field
  end
end

class TestQuery < Queries::ElasticSearch
  def define_query
    type :test_class
  end

  def validate
    true
  end
end

describe 'elastic search' do
  before do
    ElasticSearch.stub synchronous: true
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
    (TestIndexCommand.new object).execute

    (TestQuery.new query, 1, 10).execute
  end
end
