require 'spec_helper'

describe 'general' do
  include PavlovSupport

  let(:user) { create :full_user }
  let(:other_user) { create :full_user }

  it 'after adding activities they exist' do
    as(user) do |pavlov|
      fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: 'http://example.org', title: ''

      a2 = pavlov.command :'create_activity', graph_user: other_user.graph_user,
                                              action: :followed_user, subject: nil, object: nil

      all_activity_ids = Activity.all.ids
      just_created_ids = [a2].map(&:id)

      expect(all_activity_ids).to include(*just_created_ids)
    end
  end
  context 'after cleanup' do
    it 'invalid activities are removed from a list' do
      as(user) do |pavlov|
        fact_that_will_be_deleted = pavlov.interactor :'facts/create', displaystring: 'a fact', url: 'http://example.org', title: ''
        valid_fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: 'http://example.org', title: ''

        valid = pavlov.command :'create_activity', graph_user: other_user.graph_user,
                                                   action: :followed_user, subject: valid_fact, object: valid_fact
        with_invalid_subject = pavlov.command :'create_activity', graph_user: other_user.graph_user,
                                                                  action: :followed_user, subject: fact_that_will_be_deleted, object: nil
        with_invalid_object = pavlov.command :'create_activity', graph_user: other_user.graph_user,
                                                                 action: :followed_user, subject: valid_fact, object: fact_that_will_be_deleted
        valid_with_nils = pavlov.command :'create_activity', graph_user: other_user.graph_user,
                                                             action: :followed_user, subject: nil, object: nil

        fact_that_will_be_deleted.delete

        list = Nest.new(:a_list)
        list.zadd 145, valid.id
        list.zadd 12566, with_invalid_subject.id
        list.zadd 15, with_invalid_object.id
        list.zadd 1276, valid_with_nils.id
        list.zadd 26, '678678678678678677868'

        pavlov.command :'activities/clean_list', list_key: list.to_s

        list_ids = list.zrange(0, -1)

        correct_ids = [valid, valid_with_nils].map(&:id)
        faulty_ids = [with_invalid_subject, with_invalid_object].map(&:id)

        expect(list_ids).to include(*correct_ids)
        expect(list_ids).not_to include(*faulty_ids)
      end
    end
  end
end
