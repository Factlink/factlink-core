require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/by_id'

describe Queries::Topics::ById do
  include PavlovSupport

  describe '#validate' do
    before do
      described_class.any_instance.stub(authorized?: true)
    end

    it 'calls the correct validation methods' do
      interactor = described_class.new id: 'this is not hexadecimal'

      expect{ interactor.call }
        .to raise_error(Pavlov::ValidationError,
          'id should be an hexadecimal string.')
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'returns the topic Topic.find' do
      stub_classes 'Topic', 'KillObject'
      id = double
      topic = double
      dead_topic = double
      query = described_class.new id: id

      Topic.should_receive(:find).with(id).and_return(topic)
      KillObject.should_receive(:topic).with(topic).and_return(dead_topic)

      expect(query.call).to eq dead_topic
    end
  end
end
