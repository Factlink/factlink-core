require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/text_search/index.rb'

describe Commands::TextSearch::Index do
  include PavlovSupport

  before do
    stub_classes 'ElasticSearch::Index'
  end

  describe '#call' do
    it 'correctly' do
      object = double id: 13, bar: 'BAR', baz: 'BAZ'
      index = double
      ElasticSearch::Index.stub(:new).with(:foo)
                          .and_return(index)
      command = described_class.new object: object, type_name: :foo, fields: [:bar, :baz]

      index.should_receive(:add)
           .with object.id, {
             bar: object.bar,
             baz: object.baz
           }

      command.call
    end

    it 'does not index when nothing has changed' do
      object = double
      index = double
      ElasticSearch::Index.stub(:new).with(:foo)
                          .and_return(index)
      command = described_class.new object: object, type_name: :foo, fields: [:bar, :baz], fields_changed: [:unrelated]

      index.should_not_receive(:add)

      command.call
    end
  end
end
