require 'spec_helper'

describe AddAllContainingFactlinksToTopic do
  include PavlovSupport

  it 'adds all containing Factlinks to the Topics Facts' do
    channel1, channel2, channel3 = ()

    title = 'Channel Title'
    user1 = create :user
    user2 = create :user
    user3 = create :user

    as(user1) do |pavlov|
      fact1 = create :fact
      channel1 = create :channel, title: title, created_by: user1.graph_user
      pavlov.interactor :"channels/add_fact", fact1, channel1
    end

    as(user2) do |pavlov|
      fact2 = create :fact
      channel2 = create :channel, title: title, created_by: user2.graph_user
      pavlov.interactor :"channels/add_fact", fact2, channel2
    end

    as(user3) do |pavlov|
      fact3 = create :fact
      channel3 = create :channel, title: title, created_by: user3.graph_user
      pavlov.interactor :"channels/add_fact", fact3, channel3
    end

    slug_title = channel1.slug_title

    # DELETE THE WORKING PROPAGATION, to test the migration
    Topic.redis[slug_title][:facts].del

    as(user1) do |pavlov|
      nr_of_facts_before_running_job =
        pavlov.interactor(:"topics/facts", slug_title, nil, nil).length

      AddAllContainingFactlinksToTopic.perform(Topic.find_by(slug_title: slug_title).id)

      nr_of_facts_after_running_job =
        pavlov.interactor(:"topics/facts", slug_title, nil, nil).length

      expect(nr_of_facts_before_running_job).to eq 0
      expect(nr_of_facts_after_running_job).to eq 3
    end
  end

end
