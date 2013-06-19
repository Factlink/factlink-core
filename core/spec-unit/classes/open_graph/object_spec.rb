require_relative '../../../app/classes/open_graph/object.rb'

describe OpenGraph::Object do
  describe '#open_graph_field' do
    it 'should add the field to the open_graph_hash' do
      DummyClass = Class.new OpenGraph::Object do
        def initialize
          open_graph_field :foo, 'bar'
        end
      end

      open_graph_object = DummyClass.new

      expect(open_graph_object.to_hash).to eq({ 'og:foo' => 'bar' })
    end

    it 'should raise when no value is passed' do
      OtherDummyClass = Class.new OpenGraph::Object do
        def initialize
          open_graph_field :foo
        end
      end

      expect {
        OtherDummyClass.new
      }.to raise_error
    end
  end
end
