require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/sub_comments/create_xxx.rb'

describe Commands::SubComments::CreateXxx do
  include PavlovSupport
  before do
    stub_classes 'SubComment', 'User'
  end

  describe '#call' do
    it 'correctly' do
      parent_id = 1
      content = 'message'
      user = double

      pavlov_options = { current_user: user }
      command = described_class.new(parent_id: parent_id,
                                    content: content, user: user,
                                    pavlov_options: pavlov_options)
      comment = double(:comment, id: 10)

      comment.should_receive(:parent_id=).with(parent_id.to_s)
      comment.should_receive(:parent_class=).with('Comment')
      SubComment.should_receive(:new).and_return(comment)
      comment.should_receive(:created_by=).with(user)
      comment.should_receive(:content=).with(content)
      comment.should_receive(:save!)

      expect( command.call ).to eq comment
    end
  end
end
