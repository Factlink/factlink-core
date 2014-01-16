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
      count = double
      query = described_class.new parent_id: parent_id.to_s

      expect(SubComment)
        .to receive(:where)
        .with(parent_id: parent_id.to_s)
        .and_return(double(count:count))

      expect(query.call).to eq count
    end
  end

end
