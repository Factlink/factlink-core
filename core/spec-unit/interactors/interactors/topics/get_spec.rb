require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/topics/get'

describe Interactors::Topics::Get do
  include PavlovSupport

  describe 'authorized?' do
    it 'throws when no current_user' do
      expect { described_class.new 'foo' }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end

    it 'throws when cannot show' do
      topic = stub
      current_user = stub

      ability = stub
      ability.stub(:can?).with(:show, topic).and_return(false)

      pavlov_options = { current_user: current_user, ability: ability }

      described_class.any_instance.stub(:query).
        with(:'topics/get', 'foo').
        and_return(topic)

      expect { described_class.new 'foo', pavlov_options }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe 'validate' do
    it :slug_title do
      expect_validating(1).
        to fail_validation('slug_title should be a string.')
    end
  end

  describe 'execute' do
    it 'returns the topic from the query' do
      topic = stub

      described_class.any_instance.stub(:authorized?).and_return(true)

      interactor = described_class.new 'foo', {}

      interactor.stub(:query).
        with(:'topics/get', 'foo').
        and_return(topic)

      result = interactor.execute

      expect(result).to eq topic
    end
  end
end
