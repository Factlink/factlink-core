require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/twitter/share_factlink.rb'
require_relative '../../../../app/classes/quotes.rb'

describe Commands::Twitter::ShareFactlink do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Fact', 'Twitter', 'FactUrl'
    end

    it 'posts a fact with quote and sharing url' do
      fact = double(id: "1", quotes: double)
      fact_url = double sharing_url: 'sharing_url'
      url_length = 20

      Twitter.stub configuration: double(short_url_length_https: url_length)

      Pavlov.stub(:query)
            .with(:'facts/get_dead', id: fact.id)
            .and_return(fact)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      fact.quotes.stub(:trimmed_quote).with(140-url_length-1).and_return('quote')

      Pavlov.should_receive(:command)
            .with(:'twitter/post', message: 'quote sharing_url')

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
