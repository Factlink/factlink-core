require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facts/destroy'

describe Commands::Facts::Destroy do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#call' do
    it 'should remove the comment' do
      fact = double id: '14'

      command = described_class.new fact_id: fact.id
      Fact.should_receive(:[]).with(fact.id)
                .and_return(fact)

      fact.should_receive(:delete)

      command.execute
    end
  end

end
