require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/post_to_twitter.rb'

describe Interactors::Facts::PostToTwitter do
  include PavlovSupport

  before do
    stub_classes 'Fact', 'Twitter', 'FactUrl'

    Twitter.stub configuration: mock(short_url_length_https: 20)
  end

  describe '#authorized?' do
    it 'throws when cannot share facts' do
      ability = stub
      ability.stub(:can?).with(:share, Fact).and_return(false)

      pavlov_options = {current_user: mock, ability: ability}

      expect { described_class.new '1', 'message', pavlov_options }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '#call' do
    it 'posts a fact with a sharing_url if available' do
      user = mock
      message = "message"
      fact = mock(id: "1")
      sharing_url = 'sharing_url'
      fact_url = mock sharing_url: sharing_url

      pavlov_options = {current_user: user, ability: mock(can?: true)}

      Pavlov.stub(:old_query)
        .with(:"facts/get_dead", fact.id, pavlov_options)
        .and_return(fact)

      FactUrl.stub(:new)
             .with(fact)
             .and_return(fact_url)

      Pavlov.should_receive(:old_command)
        .with(:"twitter/post", "message sharing_url", pavlov_options)

      interactor = described_class.new fact.id, message, pavlov_options
      interactor.call
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact_id = "1"
      message = "message"
      user    = mock

      # 140 Twitter characters, minus url length, minus 1 for space
      maximum_message_length = 140 - Twitter.configuration.short_url_length_https - 1

      described_class.any_instance.should_receive(:validate_integer_string)
        .with(:fact_id, fact_id)
      described_class.any_instance.should_receive(:validate_nonempty_string)
        .with(:message, message)
      described_class.any_instance.should_receive(:validate_string_length)
        .with(:message, message, maximum_message_length)
      described_class.any_instance.should_receive(:validate_not_nil)
        .with(:current_user, user)

      pavlov_options = {current_user: user, ability: mock(can?: true)}

      interactor = described_class.new fact_id, message, pavlov_options
    end
  end

end
