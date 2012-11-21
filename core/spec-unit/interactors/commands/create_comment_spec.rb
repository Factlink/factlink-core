require 'pavlov_helper'
require_relative '../../../app/interactors/commands/create_comment.rb'

describe Commands::CreateComment do
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
    before do
      stub_const('Comment' ,Class.new)
      stub_const('FactData' ,Class.new)
      stub_const('User' ,Class.new)
    end

    it 'correctly' do
      fact_data_id = 'a1'
      opinion = 'believes'
      content = 'message'
      user_id = 1
      command = Commands::CreateComment.new fact_data_id, opinion, content, user_id
      comment = mock()
      Comment.should_receive(:new).and_return(comment)
      fact_data = mock()
      FactData.should_receive(:find).with(fact_data_id).and_return(fact_data)
      comment.should_receive(:fact_data=).with(fact_data)
      user = mock()
      User.should_receive(:find).with(user_id).and_return(user)
      comment.should_receive(:created_by=).with(user)
      comment.should_receive(:opinion=).with(opinion)
      comment.should_receive(:content=).with(content)
      comment.should_receive(:save)

      command.execute
    end
  end
end
