require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/sub_comments/get'

describe Queries::SubComments::Get do
  include PavlovSupport
  before do
    stub_classes 'SubComment', 'KillObject'
  end

  describe '#call' do
    it 'without id doesn''t validate' do
      expect_validating(id: nil).
        to fail_validation('id should be an hexadecimal string.')
    end

    it "should return the dead version of the subcomment" do
      sub_comment = mock :sub_comment, id: '1a'
      dead_sub_comment = mock
      query = Queries::SubComments::Get.new id: sub_comment.id

      SubComment.should_receive(:find).with(sub_comment.id)
             .and_return sub_comment
      KillObject.should_receive(:sub_comment).with(sub_comment)
                .and_return dead_sub_comment

      expect(query.call).to eq dead_sub_comment
    end
  end

end
