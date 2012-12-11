require 'spec_helper'

class TestClass
  def id
    1
  end

  attr_accessor :test_field
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
    query = 'bla'
    object = TestClass.new
    object.test_field = 'bla bla bla'
    (TestIndexCommand.new object).execute

    results = (TestQuery.new query, 1, 10).execute
    puts "WHAT: #{results}"
  end

  pending 'searches for stop words' do
    query = 'the'

  end

  pending 'searches for sequences that need to be escaped' do

  end

end
