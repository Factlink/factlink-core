require_relative '../../app/classes/open_graph_formatter.rb'

describe OpenGraphFormatter do
  describe '#to_hash' do
    it 'returns a hash with the two default keys by default' do
      default_rules = { key: double }
      formatter     = described_class.new

      formatter.stub(:default_rules).and_return(default_rules)

      expect(formatter.to_hash).to eq default_rules
    end
  end

  describe '#add' do
    it 'adds the passed GraphObjects hash presentation to the rules' do
      default_rules = { foo: 'bar' }
      graph_object  = double to_hash: { bla: 'foo' }
      formatter     = described_class.new

      formatter.stub(:default_rules).and_return(default_rules)

      formatter.add graph_object

      expect(formatter.to_hash).to eq({foo: 'bar', bla: 'foo'})
    end

    it 'overwrites the default values when a GraphObject with the same key gets added' do
      default_rules = { key: 'old_value' }
      graph_object  = double to_hash: { key: 'new_value' }
      formatter     = described_class.new

      formatter.stub(:default_rules).and_return(default_rules)

      formatter.add graph_object

      expect(formatter.to_hash).to eq graph_object.to_hash
    end
  end
end
