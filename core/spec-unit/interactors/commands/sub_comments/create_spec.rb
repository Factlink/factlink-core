require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/sub_comments/create.rb'

describe Commands::SubComments::Create do
  include PavlovSupport
  before do
    stub_classes 'SubComment', 'User'
  end

  it 'should initialize correctly' do
    command = Commands::SubComments::Create.new 1, 'FactRelation','content', '2a'

    command.should_not be_nil
  end

  describe "validation" do
    let(:subject_class) { Commands::SubComments::Create }
    it 'without user_id doesn''t validate' do
      expect_validating('1', 'Comment' ,'Hoi!', '').
        to fail_validation('user_id should be an hexadecimal string.')
    end

    it 'without content doesn''t validate' do
      expect_validating('1', 'FactRelation' ,'', '2a').
        to fail_validation('content should not be empty.')
    end

    it 'with a invalid parent_id for Comment parent class doesn''t validate' do
      expect_validating(1, 'Comment', 'Hoi!', '2a').
        to fail_validation('parent_id should be an hexadecimal string.')
    end

    it 'with a invalid parent_id for FactRelation parent class doesn''t validate' do
      expect_validating('2a', 'FactRelation', 'Hoi!', '2a').
        to fail_validation('parent_id should be an integer.')
    end

    it 'with a invalid parent_class doesn''t validate' do
      expect_validating('1', 'bla', 'Hoi!', '2a').
        to fail_validation('parent_class should be on of these values: ["Comment", "FactRelation"].')
    end
  end

  describe '.execute' do
    it 'correctly' do
      parent_id = 1
      content = 'message'
      user_id = '1a'
      parent_class = 'FactRelation'

      command = Commands::SubComments::Create.new parent_id, parent_class, content, user_id
      comment = mock(:comment, id: 10)
      user = mock

      comment.should_receive(:parent_id=).with(parent_id.to_s)
      SubComment.should_receive(:new).and_return(comment)
      User.should_receive(:find).with(user_id).and_return(user)
      comment.should_receive(:created_by=).with(user)
      comment.should_receive(:content=).with(content)
      comment.should_receive(:parent_class=).with(parent_class)
      comment.should_receive(:save)

      result = command.execute

      expect( result ).to eq comment
    end
  end
end
