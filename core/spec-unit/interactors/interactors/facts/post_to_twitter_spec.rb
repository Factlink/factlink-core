require 'pavlov_helper'
require_relative '../../../../app/helpers/fact_helper.rb'
require_relative '../../../../app/interactors/interactors/facts/post_to_twitter.rb'

describe Interactors::Facts::PostToTwitter do
  include PavlovSupport

  let(:maximum_message_length) { 130 }

  before do
    stub_classes 'FactHelper', 'Fact', 'Twitter'

    short_url_length_https = 140-maximum_message_length-1 # -1 for space
    Twitter.stub configuration: mock(short_url_length_https: short_url_length_https)
  end

  describe '#authorized?' do
    it 'throws when cannot share facts' do
      ability = stub
      ability.stub(:can?).with(:share, Fact).and_return(false)

      expect { described_class.new '1', 'message', ability: ability }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '#call' do
    it 'posts a fact with a proxy_scroll_url if available' do
      user = mock(username: "username")
      message = "message"
      fact = mock(id: "1", proxy_scroll_url: "proxy_scroll_url")

      pavlov_options = {current_user: user, ability: mock(can?: true)}

      interactor = described_class.new fact.id, message, pavlov_options

      interactor.stub(:query)
        .with(:"facts/get_dead", fact.id)
        .and_return(fact)

      interactor.should_receive(:command)
        .with(:"twitter/post", user.username, "message proxy_scroll_url")

      interactor.call
    end

    it 'posts a fact with a friendly_fact_url otherwise' do
      user = mock(username: "username")
      message = "message"
      fact = mock(id: "1", proxy_scroll_url: nil, to_s: 'displaystring')
      friendly_fact_url = "friendly_fact_url"

      pavlov_options = {current_user: user, ability: mock(can?: true)}

      interactor = described_class.new fact.id, message, pavlov_options

      interactor.stub(:query)
        .with(:"facts/get_dead", fact.id)
        .and_return(fact)

      interactor.stub(:frurl_fact_url)
        .with('displaystring', fact.id)
        .and_return(friendly_fact_url)

      interactor.should_receive(:command)
        .with(:"twitter/post", user.username, "message friendly_fact_url")

      interactor.call
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact_id = "1"
      message = "message"

      described_class.any_instance.should_receive(:validate_integer_string)
        .with(:fact_id, fact_id)
      described_class.any_instance.should_receive(:validate_nonempty_string)
        .with(:message, message)
      described_class.any_instance.should_receive(:validate_string_length)
        .with(:message, message, maximum_message_length)

      interactor = described_class.new fact_id, message, ability: mock(can?: true)
    end
  end

end
