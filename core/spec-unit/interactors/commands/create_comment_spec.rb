require 'pavlov_helper'
require_relative '../../../app/interactors/commands/create_comment.rb'

describe Commands::CreateComment do
  include PavlovSupport
  before do
    stub_classes 'Comment', 'FactData', 'User', 'Fact', 'Authority'
  end

  it 'should initialize correctly' do
    command = Commands::CreateComment.new 1, 'believes', 'hoi', '2a'

    command.should_not be_nil
  end

  describe "validation" do
    let(:subject_class) { Commands::CreateComment }
    it 'without user_id doesn''t validate' do
      expect_validating(1, 'believes', 'Hoi!', '').
        to fail_validation('user_id should be an hexadecimal string.')
    end

    it 'without content doesn''t validate' do
      expect_validating(1, 'believes', '', '2a').
        to fail_validation('content should not be empty.')
    end

    it 'with a invalid fact_data_id doesn''t validate' do
      expect_validating('x', 'believes', 'Hoi!', '2a').
        to fail_validation('fact_id should be an integer.')
    end

    it 'with a invalid type doesn''t validate' do
      expect_validating(1, 'dunno', 'Hoi!', '2a').
        to fail_validation('type should be on of these values: ["believes", "disbelieves", "doubts"].')
    end
  end

  describe '.execute' do
    it 'correctly' do
      fact_id = 1
      type = 'believes'
      content = 'message'
      user_id = '1a'
      command = Commands::CreateComment.new fact_id, type, content, user_id
      comment = mock(:comment, id: 10)
      fact = mock
      fact_data = mock fact: fact
      user = mock
      command.stub fact_data: fact_data

      comment.should_receive(:fact_data=).with(fact_data)
      Comment.should_receive(:new).and_return(comment)
      User.should_receive(:find).with(user_id).and_return(user)

      comment.should_receive(:created_by=).with(user)
      comment.should_receive(:type=).with(type)
      comment.should_receive(:content=).with(content)
      comment.should_receive(:save)

      command.execute
    end
  end

  describe '.fact_data' do
    it 'should return the fact_data defined by the fact_id' do
      fact_id = 10
      fact_data_id = 'a1'
      fact = mock(:fact, data_id: fact_data_id)
      type = 'believes'
      content = 'message'
      user_id = '1a'
      command = Commands::CreateComment.new fact_id, type, content, user_id
      fact_data = mock

      Fact.should_receive(:[]).with(fact_id).and_return(fact)
      FactData.should_receive(:find).with(fact_data_id).and_return(fact_data)

      result = command.fact_data

      expect(result).to eq(fact_data)
    end
  end
end
