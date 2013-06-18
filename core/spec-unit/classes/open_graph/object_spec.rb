require_relative '../../../app/classes/open_graph/object.rb'

describe OpenGraph::Object do
  describe '#to_hash' do
    it 'returns the hash with all keys prefixed with og:' do
      open_graph_hash = { foo: 'bar', bla: 'hoi'}

      open_graph_object = described_class.new

      open_graph_object.should_receive(:open_graph_hash).and_return open_graph_hash

      expect(open_graph_object.to_hash).to eq({'og:foo' => 'bar', 'og:bla' => 'hoi'})
    end
  end

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

    it 'should raise when the value is falsy' do
      DummyClass = Class.new OpenGraph::Object do
        def initialize
          open_graph_field :foo, ''
        end
      end

      expect(DummyClass.new).to raise_error
    end
  end
end
