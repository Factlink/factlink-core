require 'spec_helper'

describe 'top user topics per user' do
  include PavlovSupport

  let(:user)   { create :user }

  context 'user initially' do
    it 'has no last used topics' do
      as(user) do |pavlov|
        results = pavlov.query(:'user_topics/top_with_authority_for_user', user_id: user.id.to_s)
        expect(results).to eq []
      end
    end
  end

  context 'after creating some topics' do
    it 'has no last used topics' do
      as(user) do |pavlov|
        topic1 = pavlov.command(:'topics/create', title: 'Foo')
        topic2 = pavlov.command(:'topics/create', title: 'Bar')

        results = pavlov.query(:'user_topics/top_with_authority_for_user', user_id: user.id.to_s)
        expect(results).to eq []
      end
    end
  end

  context 'after creating some channels' do
    it 'has no last used topics' do
      as(user) do |pavlov|
        topic1 = pavlov.command(:'channels/create', title: 'Foo')
        topic2 = pavlov.command(:'channels/create', title: 'Bar')

        results = pavlov.query(:'user_topics/top_with_authority_for_user', user_id: user.id.to_s)
        expect(results).to eq []
      end
    end
  end

  context 'after posting to some channels' do
    it 'has those as last used topics' do
      as(user) do |pavlov|
        channel1 = pavlov.command(:'channels/create', title: 'Foo')
        channel2 = pavlov.command(:'channels/create', title: 'Bar')

        factlink = create :fact, created_by: user.graph_user

        pavlov.interactor(:'channels/add_fact_without_propagation', fact: factlink, channel: channel1)
        pavlov.interactor(:'channels/add_fact_without_propagation', fact: factlink, channel: channel2)

        results = pavlov.query(:'user_topics/top_with_authority_for_user', user_id: user.id.to_s)

        expect(results).to match_array [
          DeadUserTopic.new('foo', 'Foo'),
          DeadUserTopic.new('bar', 'Bar')
        ]
      end
    end
  end
end
