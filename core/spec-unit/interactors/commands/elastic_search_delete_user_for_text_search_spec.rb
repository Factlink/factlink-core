require 'pavlov_helper'
require_relative '../../../app/interactors/commands/elastic_search_delete_user_for_text_search.rb'

describe Commands::ElasticSearchDeleteUserForTextSearch do
  include PavlovSupport

  before do
    stub_classes 'HTTParty', 'FactlinkUI::Application'
  end

  it 'raises when user is not a User' do
    expect { Commands::ElasticSearchDeleteUserForTextSearch.new('User').call }
      .to raise_error
  end

  describe '#call' do
    it 'correctly' do
      user = double id: 1
      url = 'localhost:9200'
      config = double
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config

      HTTParty.should_receive(:delete).with("http://#{url}/user/#{user.id}")
      command = Commands::ElasticSearchDeleteUserForTextSearch.new user

      command.call
    end
  end

end

