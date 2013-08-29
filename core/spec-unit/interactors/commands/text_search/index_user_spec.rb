require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/text_search/index_user'

describe Commands::TextSearch::IndexUser do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      user = double
      changed = double
      command = described_class.new(user: user, changed: changed)

      Pavlov.should_receive(:command)
            .with(:'text_search/index',
                      object: user, type_name: :user,
                      fields: [:username, :first_name, :last_name],
                      fields_changed: changed)

      command.call
    end
  end
end
