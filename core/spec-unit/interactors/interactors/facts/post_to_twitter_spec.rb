require 'pavlov_helper'
require_relative '../../../../app/helpers/fact_helper.rb'
require_relative '../../../../app/interactors/interactors/facts/post_to_twitter.rb'

describe Interactors::Facts::PostToTwitter do
  include PavlovSupport

  before do
    stub_classes 'FactHelper', 'Fact'
  end

  describe '#authorized?' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'throws when cannot share facts' do
      ability = stub
      ability.stub(:can?).with(:share, Fact).and_return(false)

      pavlov_options = {current_user: stub, ability: ability}

      expect { described_class.new mock, mock, pavlov_options }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(validate: true, authorized?: true)
    end

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
    let(:maximum_message_length) { 130 }

    before do
      described_class.any_instance.stub(authorized?: true)
      stub_classes 'Twitter'
      short_url_length_https = 140-maximum_message_length-1 # -1 for space
      Twitter.stub configuration: mock(short_url_length_https: short_url_length_https)
    end

    it 'calls the correct validation methods' do
      fact_id = "1"
      message = "a"*maximum_message_length

      described_class.any_instance.should_receive(:validate_integer_string)
        .with(:fact_id, fact_id)
      described_class.any_instance.should_receive(:validate_nonempty_string)
        .with(:message, message)

      interactor = described_class.new fact_id, message
    end

    it 'disallows messages longer than maximum_message_length' do
      fact_id = "1"
      message = "a"*(maximum_message_length+1)
      user_name = mock

      described_class.any_instance.stub(:validate_nonempty_string)

      expect {described_class.new fact_id, message}.
        to raise_error(Pavlov::ValidationError,
          "message cannot be longer than #{maximum_message_length} characters")
    end
  end

end
