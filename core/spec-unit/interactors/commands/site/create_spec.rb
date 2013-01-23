require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/sites/create'

describe Commands::Sites::Create do
  include PavlovSupport

  describe 'validations' do
    let(:subject_class) { Commands::Sites::Create }

    it 'requires arguments' do
      expect_validating('').
        to fail_validation('url should be a nonempty string.')
    end
  end

  describe '.execute' do
    before do
      stub_classes 'Site'
    end

    it 'creates a site and returns it' do
      url = 'http://jsdares.com'
      command = Commands::Sites::Create.new url
      site = mock

      Site.should_receive(:create).with(url: url).and_return(site)

      expect(command.execute).to eq site
    end
  end
end
