require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facebook/share.rb'

describe Commands::Facebook::ShareFactlink do
  include PavlovSupport

  describe '#call' do
    it 'should share a Factlink through FbGraph' do
      message = 'message'
      fact_id = '1'
      current_user = mock

      command = described_class.new message, fact_id, current_user: current_user

      command.call
    end
  end

  describe '#validate' do
    it 'should validate if the message is a nonempty_string' do
      message = 'message'

      described_class.any_instance.should_receive(:validate_nonempty_string).with(:message, message)
      command = described_class.new message, '1'
    end

    it 'should validate if the fact_id is an integer string' do
      fact_id = '1'

      described_class.any_instance.should_receive(:validate_integer_string).with(:fact_id, fact_id)
      command = described_class.new 'message', fact_id
    end
  end
end
