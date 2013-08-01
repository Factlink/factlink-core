require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/twitter/share_factlink.rb'

describe Commands::Twitter::ShareFactlink do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Fact', 'Twitter', 'FactUrl'
    end

    it 'posts a fact with quote and sharing url' do
      user = double
      fact = mock(id: "1", displaystring: '   displaystring    ')
      fact_url = mock sharing_url: 'sharing_url'

      Twitter.stub configuration: mock(short_url_length_https: 20)

      Pavlov.stub(:old_query)
        .with(:"facts/get_dead", fact.id)
        .and_return(fact)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      Pavlov.should_receive(:old_command)
        .with(:"twitter/post", "\u201c" + "displaystring" + "\u201d" + " sharing_url")

      interactor = described_class.new fact_id: fact.id
      interactor.call
    end

    it 'trims strings that are too long and strips whitespace also for the shorter version' do
      user = double
      fact = mock(id: "1", displaystring: '   12345   asdf  ')
      fact_url = mock sharing_url: 'sharing_url'

      Twitter.stub configuration: mock(short_url_length_https: 140-10)

      Pavlov.stub(:old_query)
        .with(:"facts/get_dead", fact.id)
        .and_return(fact)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      Pavlov.should_receive(:old_command)
        .with(:"twitter/post", "\u201c" + "12345" + "\u2026" + "\u201d" + " sharing_url")

      interactor = described_class.new fact_id: fact.id
      interactor.call
    end
  end

  describe 'validations' do
    it 'requires integer fact_id' do
      expect_validating(fact_id: '')
        .to fail_validation('fact_id should be an integer string.')
    end
  end
end
