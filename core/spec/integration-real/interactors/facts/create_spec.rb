require 'spec_helper'

describe 'fact' do
  include PavlovSupport

  it 'can be created' do
    displaystring = 'displaystring'
    user = create :user

    as(user) do |pavlov|
      fact = pavlov.interactor(:'facts/create', displaystring: displaystring, url: 'http://example.org', site_title: '')

      expect(Fact[fact.id].data.displaystring).to eq displaystring
    end
  end
end
