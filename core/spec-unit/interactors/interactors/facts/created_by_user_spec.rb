require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/created_by_user.rb'

describe Interactors::Facts::CreatedByUser do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#authorized?' do
    it 'should check if the fact can be shown' do
      ability = double
      expect(ability).to receive(:can?)
        .with(:index, Fact).and_return(false)

      interactor = described_class.new username: 'foo',
        pavlov_options: { ability: ability }

      expect do
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    it 'returns the created facts of the user' do
      key = double to_s: 'key'
      graph_user = double sorted_created_facts: double(key: key)
      user = double username: 'mark', graph_user: graph_user
      facts = double

      pavlov_options = { ability: double(can?: true) }

      allow(Pavlov).to receive(:query)
        .with(:'user_by_username',
              username: user.username, pavlov_options: pavlov_options)
        .and_return(user)

      interactor = described_class.new username: user.username,
                                       from: 'inf', count: 3,
                                       pavlov_options: pavlov_options

      expect(Pavlov).to receive(:query)
        .with(:"facts/get_paginated",
              key: key.to_s, count: 3,
              from: 'inf', pavlov_options: pavlov_options)
        .and_return(facts)
      expect(interactor.call).to eq facts
    end
  end
end
