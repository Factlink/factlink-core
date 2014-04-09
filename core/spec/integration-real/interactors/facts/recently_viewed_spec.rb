require 'spec_helper'

describe 'recently viewed facts' do
  include PavlovSupport

  it 'returns recently requested and/or created facts' do
    FactoryGirl.reload

    user = create :user
    other_user = create :user
    dead_fact = nil

    as(other_user) do |pavlov|
      dead_fact = pavlov.interactor(:'facts/create', displaystring: 'hoi', site_url: 'http://example.org', site_title: '')
    end

    as(user) do |pavlov|
      pavlov.interactor(:'facts/get', id: dead_fact.id)
      pavlov.interactor(:'facts/create', displaystring: 'doei', site_url: 'http://example.org', site_title: '')

      recently_viewed = pavlov.interactor(:'facts/recently_viewed')
      verify { recently_viewed }
    end
  end
end
