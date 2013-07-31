require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/sub_comments/get'

describe Queries::SubComments::Get do
  include PavlovSupport
  before do
    stub_classes 'SubComment', 'KillObject'
  end

  describe '.validate' do
    it 'without id doesn''t validate' do
      expect_validating(nil).
        to fail_validation('id should be an hexadecimal string.')
    end
  end


  describe '#call' do
    it "should return the dead version of the subcomment" do
      sub_comment = mock :sub_comment, id: '1a'
      dead_sub_comment = mock

      SubComment.should_receive(:find).with(sub_comment.id)
             .and_return sub_comment
      query = Queries::SubComments::Get.new sub_comment.id

      KillObject.should_receive(:sub_comment).with(sub_comment)
                .and_return dead_sub_comment
      expect(query.execute).to eq dead_sub_comment
    end
  end

end
