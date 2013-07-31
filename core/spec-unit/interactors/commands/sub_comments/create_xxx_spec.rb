require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/sub_comments/create_xxx.rb'

describe Commands::SubComments::CreateXxx do
  include PavlovSupport
  before do
    stub_classes 'SubComment', 'User'
  end

  it 'should initialize correctly' do
    command = described_class.new parent_id: 1, parent_class: 'FactRelation',
      content: 'content',iuser: mock

    command.should_not be_nil
  end

  describe 'validation' do
    it 'without user doesn''t validate' do
      expect_validating(parent_id: '1', parent_class: 'Comment',
          content: 'Hoi!', user: nil)
        .to fail_validation('user should not be nil.')
    end

    it 'without content doesn''t validate' do
      expect_validating(parent_id: '1', parent_class: 'FactRelation',
          content: '', user: mock)
        .to fail_validation('content should not be empty.')
    end

    it 'with a invalid parent_id for Comment parent class doesn''t validate' do
      expect_validating(parent_id: 1, parent_class: 'Comment', content: 'Hoi!',
          user: mock)
        .to fail_validation('parent_id should be an hexadecimal string.')
    end

    it 'with a invalid parent_id for FactRelation parent class doesn''t validate' do
      expect_validating(parent_id: '2a', parent_class: 'FactRelation',
          content: 'Hoi!', user: mock)
        .to fail_validation('parent_id should be an integer.')
    end

    it 'with a invalid parent_class doesn''t validate' do
      expect_validating(parent_id: '1', parent_class: 'bla', content: 'Hoi!',
          user: mock)
        .to fail_validation('parent_class should be on of these values: ["Comment", "FactRelation"].')
    end
  end

  describe '#call' do
    it 'correctly' do
      parent_id = 1
      content = 'message'
      user = double
      parent_class = 'FactRelation'

      pavlov_options = { current_user: user }
      command = described_class.new(parent_id: parent_id,
        parent_class: parent_class, content: content, user: user,
        pavlov_options: pavlov_options)
      comment = mock(:comment, id: 10)

      comment.should_receive(:parent_id=).with(parent_id.to_s)
      SubComment.should_receive(:new).and_return(comment)
      comment.should_receive(:created_by=).with(user)
      comment.should_receive(:content=).with(content)
      comment.should_receive(:parent_class=).with(parent_class)
      comment.should_receive(:save)

      expect( command.call ).to eq comment
    end
  end
end
