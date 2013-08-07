require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_index_user_for_text_search'

describe Commands::ElasticSearchIndexUserForTextSearch do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      user = double
      command = described_class.new(user: user)

      Pavlov.should_receive(:old_command)
            .with :elastic_search_index_for_text_search,
                    user,
                    :user,
                    [:username, :first_name, :last_name]

      command.call
    end
  end
end
