require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/sub_comments/destroy'

describe Commands::SubComments::Destroy do
  include PavlovSupport

  before do
    stub_classes 'SubComment'
  end

  describe '.validate' do
    it 'without id doesn\'t validate' do
      expect_validating(id: nil).
        to fail_validation('id should be an hexadecimal string.')
    end
  end


  describe '#call' do
    it "should remove the comment" do
      sub_comment = double id: '1a'

      command = described_class.new id: sub_comment.id
      SubComment.should_receive(:find).with(sub_comment.id)
                .and_return(sub_comment)

      sub_comment.should_receive(:delete)

      command.execute
    end
  end
end
