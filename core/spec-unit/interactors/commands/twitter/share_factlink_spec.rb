require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/twitter/share_factlink.rb'
require_relative '../../../../app/classes/trimmed_string.rb'

describe Commands::Twitter::ShareFactlink do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Fact', 'Twitter', 'FactUrl'
    end

    it 'posts a fact with text and sharing url' do
      fact = double(id: "1")
      fact_url = double sharing_url: 'sharing_url'
      url_length = 20
      text = 'text'

      Twitter.stub configuration: double(short_url_length_https: url_length)

      Pavlov.stub(:query)
            .with(:'facts/get_dead', id: fact.id)
            .and_return(fact)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      Pavlov.should_receive(:command)
            .with(:'twitter/post', message: 'text sharing_url')

      interactor = described_class.new fact_id: fact.id, text: text
      interactor.call
    end

    it 'posts a fact with quote when no text is given' do
      fact = double(id: "1")
      fact_url = double sharing_url: 'sharing_url'
      url_length = 20

      Twitter.stub configuration: double(short_url_length_https: url_length)

      Pavlov.stub(:query)
            .with(:'facts/get_dead', id: fact.id)
            .and_return(fact)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      fact.stub(:trimmed_quote).with(140-url_length-1).and_return('quote')

      Pavlov.should_receive(:command)
            .with(:'twitter/post', message: 'quote sharing_url')

      interactor = described_class.new fact_id: fact.id, text: nil
      interactor.call
    end
  end
end
