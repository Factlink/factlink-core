require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/by_id'

describe Queries::Topics::ById do
  include PavlovSupport

  describe '#validate' do
    before do
      described_class.any_instance.stub(authorized?: true)
    end

    it 'calls the correct validation methods' do
      id = double

      described_class.any_instance.should_receive(:validate_hexadecimal_string).
        with(:id, id)

      interactor = described_class.new id
    end
  end

  describe '#execute' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'returns the topic Topic.find' do
      stub_classes 'Topic', 'KillObject'

      id = double
      topic = double
      dead_topic = double

      Topic.should_receive(:find).with(id).and_return(topic)
      KillObject.should_receive(:topic).with(topic).and_return(dead_topic)

      query = described_class.new id, {}

      result = query.execute
      expect(result).to eq dead_topic
    end
  end
end
