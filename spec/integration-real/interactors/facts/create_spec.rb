require 'spec_helper'

describe 'fact' do
  include PavlovSupport

  it 'can be created' do
    displaystring = 'displaystring'
    user = create :user

    as(user) do |pavlov|
      dead_fact = pavlov.interactor(:'facts/create', displaystring: displaystring, site_url: 'http://example.org', site_title: '')

      dead_fact_again = pavlov.interactor(:'facts/get', id: dead_fact.id)
      expect(dead_fact_again.displaystring).to eq displaystring
    end
  end
end
