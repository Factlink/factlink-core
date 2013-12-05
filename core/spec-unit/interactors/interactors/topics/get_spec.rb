require 'pavlov_helper'
require './app/interactors/interactors/topics/get'

describe Interactors::Topics::Get do
  include PavlovSupport

  describe 'authorized?' do
    it 'throws when cannot show' do
      topic = double
      current_user = double

      ability = double
      ability.stub(:can?).with(:show, topic).and_return(false)
      pavlov_options = { current_user: current_user, ability: ability }
      interactor = described_class.new slug_title: 'foo',
                                       pavlov_options: pavlov_options

      Pavlov.stub(:query)
        .with(:'topics/by_slug_title', slug_title: 'foo', pavlov_options: pavlov_options)
        .and_return(topic)

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
      topic = double
      interactor = described_class.new(slug_title: 'foo')

      described_class.any_instance.stub(:authorized?).and_return(true)
      Pavlov.stub(:query)
        .with(:'topics/by_slug_title', slug_title: 'foo')
        .and_return(topic)

      expect(interactor.topic).to eq topic
    end
  end

  describe '#call' do
    it 'should return a dead object' do
      topic = double(slug_title: 'slug_title', title: 'title')
      dead_topic = double
      stub_classes 'DeadTopic'
      interactor = described_class.new(slug_title: 'foo')

      described_class.any_instance.stub(:authorized?).and_return(true)
      interactor.stub(:topic).and_return(topic)

      DeadTopic.should_receive(:new).
        with(topic.slug_title, topic.title).
        and_return(dead_topic)

      expect(interactor.call).to eq dead_topic
    end
  end
end
