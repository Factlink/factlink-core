require 'spec_helper'

describe 'top user topics per user' do
  include PavlovSupport

  let(:user)   { create :user }

  context 'user initially' do
    it 'has no last used topics' do
      as(user) do |pavlov|
        results = pavlov.query(:'user_topics/top_for_user',
                                 user_id: user.id.to_s, limit_topics: 10)
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

        pavlov.interactor(:'channels/add_fact', fact: factlink, channel: channel1)
        pavlov.interactor(:'channels/add_fact', fact: factlink, channel: channel2)

        results = pavlov.query(:'user_topics/top_for_user',
                                 user_id: user.id.to_s, limit_topics: 10)

        expect(results).to match_array [
          DeadUserTopic.new('foo', 'Foo'),
          DeadUserTopic.new('bar', 'Bar')
        ]
      end
    end
  end
end
