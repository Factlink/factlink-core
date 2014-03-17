require 'spec_helper'

describe 'general' do
  include PavlovSupport

  let(:user) { create :user }
  let(:other_user) { create :user }

  it 'after adding activities they exist' do
    as(user) do |pavlov|
      pavlov.interactor :'facts/create', displaystring: 'a fact', url: 'http://example.org', site_title: ''

      a2 = pavlov.command :'create_activity', graph_user: other_user.graph_user,
                                              action: :followed_user, subject: nil, object: nil

      all_activity_ids = Activity.all.ids
      just_created_ids = [a2].map(&:id)

      expect(all_activity_ids).to include(*just_created_ids)
    end
  end
end
