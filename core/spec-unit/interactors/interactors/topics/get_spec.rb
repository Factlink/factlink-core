require 'pavlov_helper'
require './app/interactors/interactors/topics/get'

describe Interactors::Topics::Get do
  include PavlovSupport

  describe 'authorized?' do
    it 'throws when no current_user' do
      expect { described_class.new(slug_title: 'foo').call }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end

    it 'throws when cannot show' do
      topic = stub
      current_user = stub
      ability = stub
      ability.stub(:can?).with(:show, topic).and_return(false)
      pavlov_options = { current_user: current_user, ability: ability }
      interactor = described_class.new slug_title: 'foo',
        pavlov_options: pavlov_options

      described_class.any_instance.stub(:old_query).
        with(:'topics/by_slug_title', 'foo').
        and_return(topic)

      expect do
        interactor.call
      end.to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe 'validations' do
    it :slug_title do
      expect_validating(slug_title: 1).
        to fail_validation('slug_title should be a string.')
    end
  end

  describe '#topic' do
    it 'returns the topic from the query' do
      topic = stub
      interactor = described_class.new(slug_title: 'foo')

      described_class.any_instance.stub(:authorized?).and_return(true)
      interactor.stub(:old_query).
        with(:'topics/by_slug_title', 'foo').
        and_return(topic)

      expect(interactor.topic).to eq topic
    end
  end

  describe '#authority' do
    it 'returns the authority from the query' do
      topic = stub
      graph_user = stub
      user = stub(graph_user: graph_user)
      authority = stub
      interactor = described_class.new(slug_title: 'foo',
        pavlov_options: {current_user: user})

      described_class.any_instance.stub(:authorized?).and_return(true)
      interactor.stub(:old_query).
        with(:'topics/by_slug_title', 'foo').
        and_return(topic)

      interactor.should_receive(:old_query).
        with(:authority_on_topic_for, topic, graph_user).
        and_return(authority)

      expect(interactor.authority).to eq authority
    end
  end

  describe '#call' do
    it 'should return a dead object' do
      topic = stub
      authority = stub
      dead_topic = stub
      stub_classes 'KillObject'
      interactor = described_class.new(slug_title: 'foo')

      described_class.any_instance.stub(:authorized?).and_return(true)
      interactor.stub(:topic).and_return(topic)
      interactor.stub(:authority).and_return(authority)

      KillObject.should_receive(:topic).
        with(topic, current_user_authority: authority).
        and_return(dead_topic)

      expect(interactor.call).to eq dead_topic
    end
  end
end
