require 'spec_helper'

describe 'recently viewed facts' do
  include PavlovSupport

  it 'returns recently requested and/or created facts' do
    FactoryGirl.reload

    user = create :user
    other_user = create :user
    fact = nil

    as(other_user) do |pavlov|
      fact = pavlov.interactor(:'facts/create', displaystring: 'hoi', url: 'http://example.org', site_title: '')
    end

    as(user) do |pavlov|
      pavlov.interactor(:'facts/get', id: fact.id)
      pavlov.interactor(:'facts/create', displaystring: 'doei', url: 'http://example.org', site_title: '')

      recently_viewed = pavlov.interactor(:'facts/recently_viewed')
      verify { recently_viewed }
    end
  end
end
