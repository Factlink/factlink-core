require 'spec_helper'

describe Interactors::Topics::Facts do
  include PavlovSupport

  let(:user) {create :user}

  it 'after adding activities they exist' do
    as(user) do |pavlov|
      fact = pavlov.interactor :'facts/create', 'a fact', '', ''
      channel = pavlov.command :'channels/create', 'something'

      created_facts = channel.created_by.created_facts_channel
      stream = channel.created_by.stream

      a1 = pavlov.command :create_activity, channel.created_by,
                       :added_fact_to_channel, fact, channel
      a2 = pavlov.command :create_activity, channel.created_by,
                       :added_fact_to_channel, fact, created_facts
      a3 = pavlov.command :create_activity, channel.created_by,
                       :added_fact_to_channel, fact, stream
      a4 = pavlov.command :create_activity, channel.created_by,
                       :foo, nil, nil

      all_activity_ids = Activity.all.ids
      just_created_ids = [a1, a2, a3, a4].map(&:id)

      expect(all_activity_ids).to include(*just_created_ids)
    end
  end
  context 'after cleaning up faulty added_fact_to_channel activities' do
    it 'faulty activities are removed' do
      as(user) do |pavlov|
        fact = pavlov.interactor :'facts/create', 'a fact', '', ''
        channel = pavlov.command :'channels/create', 'something'

        created_facts = channel.created_by.created_facts_channel
        stream = channel.created_by.stream

        a1 = pavlov.command :create_activity, channel.created_by,
                         :added_fact_to_channel, fact, channel
        a2 = pavlov.command :create_activity, channel.created_by,
                         :added_fact_to_channel, fact, created_facts
        a3 = pavlov.command :create_activity, channel.created_by,
                         :added_fact_to_channel, fact, stream
        a4 = pavlov.command :create_activity, channel.created_by,
                         :foo, nil, nil

        pavlov.command :'activities/clean_up_faulty_add_fact_to_channels'

        all_activity_ids = Activity.all.ids
        correct_ids = [a1, a4].map(&:id)
        faulty_ids = [a2, a3].map(&:id)

        expect(all_activity_ids).to include(*correct_ids)
        expect(all_activity_ids).not_to include(*faulty_ids)
      end
    end
  end
end
