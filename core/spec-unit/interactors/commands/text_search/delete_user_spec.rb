require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/text_search/delete_user.rb'

describe Commands::TextSearch::DeleteUser do
  include PavlovSupport

  before do
    stub_classes 'ElasticSearch::Index'
  end

  it 'raises when user has no id' do
    expect { described_class.new(object: 'User').call }
      .to raise_error
  end

  describe '#call' do
    it 'correctly' do
      user = double id: 1
      url = 'localhost:9200'
      index = double
      ElasticSearch::Index.stub(:new).with('user').and_return(index)
      command = described_class.new object: user

      index.should_receive(:delete).with(user.id)

      command.call
    end
  end

end

