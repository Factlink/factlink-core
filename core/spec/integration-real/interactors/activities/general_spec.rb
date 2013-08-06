require 'spec_helper'

describe Interactors::Topics::Facts do
  include PavlovSupport

  let(:user) {create :user}

  it 'after adding activities they exist' do
    as(user) do |pavlov|
      fact = pavlov.old_interactor :'facts/create', 'a fact', '', '', {}
      channel = pavlov.old_command :'channels/create', 'something'

      created_facts = channel.created_by.created_facts_channel
      stream = channel.created_by.stream

      a1 = pavlov.old_command :create_activity, channel.created_by,
                       :added_fact_to_channel, fact, channel
      a2 = pavlov.old_command :create_activity, channel.created_by,
                       :added_fact_to_channel, fact, created_facts
      a3 = pavlov.old_command :create_activity, channel.created_by,
                       :added_fact_to_channel, fact, stream
      a4 = pavlov.old_command :create_activity, channel.created_by,
                       :foo, nil, nil

      all_activity_ids = Activity.all.ids
      just_created_ids = [a1, a2, a3, a4].map(&:id)

      expect(all_activity_ids).to include(*just_created_ids)
    end
  end
  context 'after cleaning up faulty added_fact_to_channel activities' do
    it 'faulty activities are removed' do
      as(user) do |pavlov|
        fact = pavlov.old_interactor :'facts/create', 'a fact', '', '', {}
        channel = pavlov.old_command :'channels/create', 'something'

        created_facts = channel.created_by.created_facts_channel
        stream = channel.created_by.stream

        a1 = pavlov.old_command :create_activity, channel.created_by,
                         :added_fact_to_channel, fact, channel
        a2 = pavlov.old_command :create_activity, channel.created_by,
                         :added_fact_to_channel, fact, created_facts
        a3 = pavlov.old_command :create_activity, channel.created_by,
                         :added_fact_to_channel, fact, stream
        a4 = pavlov.old_command :create_activity, channel.created_by,
                         :foo, nil, nil

        pavlov.old_command :'activities/clean_up_faulty_add_fact_to_channels'

        all_activity_ids = Activity.all.ids
        correct_ids = [a1, a4].map(&:id)
        faulty_ids = [a2, a3].map(&:id)

        expect(all_activity_ids).to include(*correct_ids)
        expect(all_activity_ids).not_to include(*faulty_ids)
      end
    end
  end
  context 'after cleanup' do
    it 'invalid activities are removed from a list' do
      as(user) do |pavlov|
        fact = pavlov.old_interactor :'facts/create', 'a fact', '', '', {}
        fact2 = pavlov.old_interactor :'facts/create', 'a fact', '', '', {}
        fact3 = pavlov.old_interactor :'facts/create', 'a fact', '', '', {}
        channel = pavlov.old_command :'channels/create', 'something'
        channel2 = pavlov.old_command :'channels/create', 'something else'

        valid = pavlov.old_command :create_activity, channel.created_by,
                         :foo, fact3, channel2
        with_invalid_subject = pavlov.old_command :create_activity, channel.created_by,
                         :foo, fact, nil
        with_invalid_object = pavlov.old_command :create_activity, channel.created_by,
                         :foo, fact2, channel
        valid_with_nils = pavlov.old_command :create_activity, channel.created_by,
                         :foo, nil, nil

        fact.delete
        channel.delete

        list = Nest.new(:a_list)
        list.zadd 145, valid.id
        list.zadd 12566, with_invalid_subject.id
        list.zadd 15, with_invalid_object.id
        list.zadd 1276, valid_with_nils.id
        list.zadd 26, '678678678678678677868'


        pavlov.old_command :'activities/clean_list', list.to_s

        list_ids = list.zrange(0, -1)

        correct_ids = [valid, valid_with_nils].map(&:id)
        faulty_ids = [with_invalid_subject, with_invalid_object].map(&:id)

        expect(list_ids).to include(*correct_ids)
        expect(list_ids).not_to include(*faulty_ids)
      end
    end
  end
end
