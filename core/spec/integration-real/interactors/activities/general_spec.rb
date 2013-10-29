require 'spec_helper'

describe Interactors::Topics::Facts do
  include PavlovSupport

  let(:user) {create :full_user}

  it 'after adding activities they exist' do
    as(user) do |pavlov|
      fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {}
      channel = pavlov.command :'channels/create', title: 'something'

      a1 = pavlov.command :'create_activity', graph_user: channel.created_by,
             action: :added_fact_to_channel, subject: fact, object: channel
      a2 = pavlov.command :'create_activity', graph_user: channel.created_by,
             action: :foo, subject: nil, object: nil

      all_activity_ids = Activity.all.ids
      just_created_ids = [a1, a2].map(&:id)

      expect(all_activity_ids).to include(*just_created_ids)
    end
  end
  context 'after cleanup' do
    it 'invalid activities are removed from a list' do
      as(user) do |pavlov|
        fact = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {}
        fact2 = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {}
        fact3 = pavlov.interactor :'facts/create', displaystring: 'a fact', url: '', title: '', sharing_options: {}
        channel = pavlov.command :'channels/create', title: 'something'
        channel2 = pavlov.command :'channels/create', title: 'something else'

        valid = pavlov.command :'create_activity', graph_user: channel.created_by,
                  action: :foo, subject: fact3, object: channel2
        with_invalid_subject = pavlov.command :'create_activity', graph_user: channel.created_by,
                  action: :foo, subject: fact, object: nil
        with_invalid_object = pavlov.command :'create_activity', graph_user: channel.created_by,
                  action: :foo, subject: fact2, object: channel
        valid_with_nils = pavlov.command :'create_activity', graph_user: channel.created_by,
                  action: :foo, subject: nil, object: nil

        fact.delete
        channel.delete

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
