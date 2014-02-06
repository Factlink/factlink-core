require 'pavlov_helper'
require_relative '../../../app/interactors/commands/comments/create.rb'

describe Commands::Comments::Create do
  include PavlovSupport
  before do
    stub_classes 'Comment', 'FactData', 'User', 'Fact', 'KillObject'
  end

  describe '#call' do
    it 'correctly' do
      fact_id = 1
      type = 'believes'
      content = 'message'
      user_id = '1a'
      command = described_class.new fact_id: fact_id, type: type,
                                    content: content, user_id: user_id
      comment = double(:comment, id: 10)
      fact = double
      fact_data = double fact: fact
      user = double
      command.stub fact_data: fact_data

      comment.should_receive(:fact_data=).with(fact_data)
      Comment.should_receive(:new).and_return(comment)
      User.should_receive(:find).with(user_id).and_return(user)

      comment.should_receive(:created_by=).with(user)
      comment.should_receive(:content=).with(content)
      comment.should_receive(:save!)

      expect(command.call).to eq comment
    end
  end

  describe '.fact_data' do
    it 'should return the fact_data defined by the fact_id' do
      fact_id = 10
      fact_data_id = 'a1'
      fact = double(:fact, data_id: fact_data_id)
      type = 'believes'
      content = 'message'
      user_id = '1a'
      command = described_class.new fact_id: fact_id, type: type,
                                    content: content, user_id: user_id
      fact_data = double

      Fact.should_receive(:[]).with(fact_id).and_return(fact)
      FactData.should_receive(:find).with(fact_data_id).and_return(fact_data)

      result = command.fact_data

      expect(result).to eq(fact_data)
    end
  end
end
