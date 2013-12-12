require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/sub_comments/count'

describe Queries::SubComments::Count do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes('SubComment')
    end

    it 'calls the index query and counts the results' do
      parent_id = 1
      parent_class = 'FactRelation'
      count = double
      query = described_class.new parent_id: parent_id.to_s,
                                  parent_class: parent_class

      SubComment.should_receive(:where).with(parent_id: parent_id.to_s, parent_class: parent_class).and_return(double(count:count))

      expect(query.call).to eq count
    end
  end

  describe '.normalized_parent_id' do
    it 'converts to an integer if the class is FactRelation' do
      parent_id = '1'
      parent_class = 'FactRelation'
      query = described_class.new parent_id: parent_id,
                                  parent_class: parent_class

      expect(query.normalized_parent_id).to eq parent_id.to_i
    end

    it 'returns a string if the class is Comment' do
      parent_id = '2a'
      parent_class = 'Comment'
      query = described_class.new parent_id: parent_id,
                                  parent_class: parent_class

      expect(query.normalized_parent_id).to eq parent_id
    end
  end
end
