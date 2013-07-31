require 'pavlov_helper'
require_relative '../../../app/interactors/commands/create_comment.rb'

describe Commands::CreateComment do
  include PavlovSupport
  before do
    stub_classes 'Comment', 'FactData', 'User', 'Fact', 'Authority'
  end

  it 'should initialize correctly' do
    command = described_class.new fact_id: 1, type: 'believes', content: 'hoi',
      user_id: '2a'

    command.should_not be_nil
  end

  describe 'validations' do
    it 'without user_id doesn\'t validate' do
      expect_validating(fact_id: 1, type: 'believes', content: 'Hoi!', user_id: 'not hex')
        .to fail_validation('user_id should be an hexadecimal string.')
    end

    it 'without content doesn\'t validate' do
      expect_validating(fact_id: 1, type: 'believes', content: '', user_id: '2a')
        .to fail_validation('content should not be empty.')
    end

    it 'with a invalid fact_data_id doesn\'t validate' do
      expect_validating(fact_id: 'x', type: 'believes', content: 'Hoi!', user_id: '2a')
        .to fail_validation('fact_id should be an integer.')
    end

    it 'with a invalid type doesn\'t validate' do
      expect_validating(fact_id: 1, type: 'dunno', content: 'Hoi!', user_id: '2a')
        .to fail_validation('type should be on of these values: ["believes", "disbelieves", "doubts"].')
    end
  end

  describe '#call' do
    before do
      stub_classes('KillObject')
    end

    it 'correctly' do
      fact_id = 1
      type = 'believes'
      content = 'message'
      user_id = '1a'
      command = described_class.new fact_id: fact_id, type: type,
        content: content, user_id: user_id
      comment = mock(:comment, id: 10)
      fact = mock
      fact_data = mock fact: fact
      user = mock
      command.stub fact_data: fact_data

      comment.should_receive(:fact_data=).with(fact_data)
      comment.should_receive(:sub_comments_count=).with(0)
      Comment.should_receive(:new).and_return(comment)
      User.should_receive(:find).with(user_id).and_return(user)

      comment.should_receive(:created_by=).with(user)
      comment.should_receive(:type=).with(type)
      comment.should_receive(:content=).with(content)
      comment.should_receive(:save)

      KillObject.should_receive(:comment).with(comment)

      command.call
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
      command = described_class.new fact_id: fact_id, type: type,
        content: content, user_id: user_id
      fact_data = mock

      Fact.should_receive(:[]).with(fact_id).and_return(fact)
      FactData.should_receive(:find).with(fact_data_id).and_return(fact_data)

      result = command.fact_data

      expect(result).to eq(fact_data)
    end
  end
end
