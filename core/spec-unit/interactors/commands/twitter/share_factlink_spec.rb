require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/twitter/share_factlink.rb'

describe Commands::Twitter::ShareFactlink do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Fact', 'Twitter', 'FactUrl'
    end

    it 'posts a fact with quote and sharing url' do
      user = mock
      fact = mock(id: "1", displaystring: '   displaystring    ')
      fact_url = mock sharing_url: 'sharing_url'

      Twitter.stub configuration: mock(short_url_length_https: 20)

      Pavlov.stub(:query)
        .with(:"facts/get_dead", fact.id)
        .and_return(fact)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      Pavlov.should_receive(:command)
        .with(:"twitter/post", "\u201c" + "displaystring" + "\u201d" + " sharing_url")

      interactor = described_class.new fact.id
      interactor.call
    end

    it 'trims strings that are too long and strips whitespace also for the shorter version' do
      user = mock
      fact = mock(id: "1", displaystring: '   12345   asdf  ')
      fact_url = mock sharing_url: 'sharing_url'

      Twitter.stub configuration: mock(short_url_length_https: 140-10)

      Pavlov.stub(:query)
        .with(:"facts/get_dead", fact.id)
        .and_return(fact)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      Pavlov.should_receive(:command)
        .with(:"twitter/post", "\u201c" + "12345" + "\u2026" + "\u201d" + " sharing_url")

      interactor = described_class.new fact.id
      interactor.call
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact_id = "1"

      described_class.any_instance.should_receive(:validate_integer_string)
        .with(:fact_id, fact_id)

      interactor = described_class.new fact_id
    end
  end

end
