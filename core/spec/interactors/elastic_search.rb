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

#This is an elasticsearch integration test
describe 'elastic search' do
  it 'searches for operators' do
    query = 'not'
    object = TestClass.new
    object.test_field = 'this is not making sense'
    object.id = '1'
    (TestIndexCommand.new object).execute

    results = (TestQuery.new query, 1, 10).execute

    results.length.should eq 1
    results[0].id.should eq object.id
  end

  it 'searches for stop words' do
    query = 'the'
    object = TestClass.new
    object.test_field = 'this is the document body'
    object.id = '1'
    (TestIndexCommand.new object).execute

    results = (TestQuery.new query, 1, 10).execute

    results.length.should eq 1
    results[0].id.should eq object.id
  end

  it 'searches for sequences that need to be escaped doesn''t throw an error' do
    query = '+ - && || ! ( ) { } [ ] ^ " ~ * ? : \\'
    object = TestClass.new
    object.test_field = 'this is the document body'
    object.id = 1
    (TestIndexCommand.new object).execute

    results = (TestQuery.new query, 1, 10).execute
  end

  it 'searches for one letter' do
    query = 'm'
    object = TestClass.new
    object.test_field = 'merry christmas'
    object.id = "1"
    (TestIndexCommand.new object).execute

    results = (TestQuery.new query, 1, 10).execute

    results.length.should eq 1
    results[0].id.should eq object.id
  end
end
