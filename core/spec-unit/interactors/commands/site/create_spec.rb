require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/sites/create'

describe Commands::Sites::Create do
  include PavlovSupport

  describe 'validations' do
    it 'requires arguments' do
      expect_validating(url: '')
        .to fail_validation('url should be a nonempty string.')
    end
  end

  describe '#call' do
    before do
      stub_classes 'Site'
    end

    it 'creates a site and returns it' do
      url = 'http://jsdares.com'
      command = described_class.new url: url
      site = mock

      Site.should_receive(:create).with(url: url).and_return(site)

      expect(command.execute).to eq site
    end
  end
end
