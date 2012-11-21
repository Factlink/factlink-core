require 'pavlov_helper'
require_relative '../../../app/interactors/commands/create_comment.rb'

describe Commands::CreateComment do
  include PavlovSupport
  before do
    stub_classes 'Comment', 'FactData', 'User'
  end

  it 'should initialize correctly' do
    command = Commands::CreateComment.new 'a1', 'believes', 'hoi', 2
    command.should_not be_nil
  end

  it 'without user_id doesn''t validate' do
    expect { Commands::CreateComment.new 'a1', 'believes', 'Hoi!', '' }.
      to raise_error(Pavlov::ValidationError, 'user_id should be a integer.')
  end

  it 'without content doesn''t validate' do
    expect { Commands::CreateComment.new 'a1', 'believes', '', 2 }.
      to raise_error(Pavlov::ValidationError, 'content should not be empty.')
  end

  it 'with a invalid fact_data_id doesn''t validate' do
    expect { Commands::CreateComment.new 'g6', 'believes', 'Hoi!', 2 }.
      to raise_error(Pavlov::ValidationError, 'fact_data_id should be an hexadecimal string.')
  end

  it 'with a invalid opinion doesn''t validate' do
    expect { Commands::CreateComment.new 'a1', 'dunno', 'Hoi!', 2 }.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  describe '.execute' do
    it 'correctly' do
      fact_data_id = 'a1'
      opinion = 'believes'
      content = 'message'
      user_id = 1
      command = Commands::CreateComment.new fact_data_id, opinion, content, user_id
      comment = mock
      fact_data = mock
      user = mock

      comment.should_receive(:fact_data=).with(fact_data)
      Comment.should_receive(:new).and_return(comment)
      FactData.should_receive(:find).with(fact_data_id).and_return(fact_data)
      User.should_receive(:find).with(user_id).and_return(user)
      comment.should_receive(:created_by=).with(user)
      comment.should_receive(:opinion=).with(opinion)
      comment.should_receive(:content=).with(content)
      comment.should_receive(:save)

      command.execute
    end
  end

  describe '.fact_data' do
    it 'should return the fact_data defined by the fact_data_id' do
      fact_data_id = 'a1'
      opinion = 'believes'
      content = 'message'
      user_id = 1
      command = Commands::CreateComment.new fact_data_id, opinion, content, user_id
      fact_data = mock

      FactData.should_receive(:find).with(fact_data_id).and_return(fact_data)
      expect(command.fact_data).to eq(fact_data)
    end
  end
end
