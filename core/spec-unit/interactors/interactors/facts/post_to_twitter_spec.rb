require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/post_to_twitter.rb'

describe Interactors::Facts::PostToTwitter do
  include PavlovSupport

  before do
    stub_classes 'Fact', 'Twitter', 'FactUrl'

    Twitter.stub configuration: double(short_url_length_https: 20)
  end

  describe '#authorized?' do
    it 'throws when cannot share facts' do
      ability = double
      ability.stub(:can?).with(:share, Fact).and_return(false)

      pavlov_options = { current_user: double, ability: ability }

      interactor = described_class.new fact_id: '1', message: 'message',
        pavlov_options: pavlov_options

      expect { interactor.call }
        .to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '#call' do
    it 'posts a fact with a sharing_url if available' do
      user = double
      message = "message"
      fact = double(id: "1")
      sharing_url = 'sharing_url'
      fact_url = double sharing_url: sharing_url

      pavlov_options = { current_user: user, ability: double(can?: true) }

      Pavlov.stub(:query)
            .with(:'facts/get_dead',
                      id: fact.id, pavlov_options: pavlov_options)
            .and_return(fact)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      Pavlov.should_receive(:command)
            .with(:'twitter/post',
                      message: "message sharing_url", pavlov_options: pavlov_options)

      interactor = described_class.new fact_id: fact.id, message: message,
        pavlov_options: pavlov_options
      interactor.call
    end
  end

  describe 'validation' do
    it 'requires fact_id to be an integer string' do
      fact_id = 1
      message = 'message'

      hash = { fact_id: fact_id, message: message,
        pavlov_options: { current_user: double }}

      expect_validating(hash)
        .to fail_validation('fact_id should be an integer string.')
    end

    it 'requires message to be a nonempty string' do
      fact_id = '1'
      message = ''

      hash = { fact_id: fact_id, message: message,
        pavlov_options: { current_user: double }}

      expect_validating(hash)
        .to fail_validation('message should be a nonempty string.')
    end

    it 'requires message to not be too long' do
      fact_id = '1'
      message = 'aa'*150

      maximum_message_length = 140 - Twitter.configuration.short_url_length_https - 1

      hash = { fact_id: fact_id, message: message,
        pavlov_options: { current_user: double }}

      expect_validating(hash)
        .to fail_validation("message should not be longer than #{maximum_message_length} characters.")
    end

    it 'requires a current_user' do
      fact_id = '1'
      message = 'message'

      hash = { fact_id: fact_id, message: message,
        pavlov_options: { current_user: nil }}

      expect_validating(hash)
        .to fail_validation('current_user should not be nil.')
    end
  end
end
