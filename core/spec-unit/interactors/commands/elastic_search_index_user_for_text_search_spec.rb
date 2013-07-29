require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_index_user_for_text_search.rb'

describe Commands::ElasticSearchIndexUserForTextSearch do
  include PavlovSupport

  let(:user) do
    double(id: 1, username: 'codinghorror', first_name: 'Sjaak',
      last_name: 'afhaak')
  end

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
  end

  describe 'validations' do
    it 'raises when user is not a User' do
      command = described_class.new(object: 'User')
      expect { command.call }.
        to raise_error(RuntimeError, 'user missing fields ([:username, :first_name, :last_name, :id]).')
    end
  end

  describe '#call' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config
      url = "http://#{url}/user/#{user.id}"
      command = described_class.new user
      json_document = mock

      command.should_receive(:json_document).and_return(json_document)
      HTTParty.should_receive(:put).with(url, { body: json_document })

      command.call
    end
  end
end
