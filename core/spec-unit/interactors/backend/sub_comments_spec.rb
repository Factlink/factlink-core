require 'pavlov_helper'
require_relative '../../../app/interactors/backend/sub_comments'

describe Backend::SubComments do
  include PavlovSupport
  before do
    stub_classes('SubComment')
  end

  describe '#count' do
    it 'counts the number of subcomments in mongo' do
      parent_id = 1

      expect(SubComment)
        .to receive(:where)
        .with(parent_id: parent_id.to_s)
        .and_return(double(count: 4))

      result = Backend::SubComments.count(parent_id: parent_id)

      expect(result).to eq 4
    end
  end
end
