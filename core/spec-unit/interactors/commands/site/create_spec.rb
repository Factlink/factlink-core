require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/sites/create'

describe Commands::Sites::Create do
  include PavlovSupport

  describe '#call' do
    it 'creates a site and returns it' do
      stub_classes 'Site'
      url = 'http://jsdares.com'
      command = described_class.new url: url
      site = double

      Site.should_receive(:create).with(url: url).and_return(site)

      expect(command.execute).to eq site
    end
  end
end
