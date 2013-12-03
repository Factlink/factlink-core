require 'spec_helper'

describe 'last used user topics per user' do
  include PavlovSupport

  let(:user)   { create :user }

  context 'user initially' do
    it 'has no last used topics' do
      as(user) do |pavlov|
        results = pavlov.query(:'user_topics/last_used_for_user', user_id: user.id.to_s)
        expect(results).to eq []
      end
    end
  end

  context 'after creating some topics' do
    it 'has no last used topics' do
      as(user) do |pavlov|
        topic1 = pavlov.command(:'topics/create', title: 'Foo')
        topic2 = pavlov.command(:'topics/create', title: 'Bar')

        results = pavlov.query(:'user_topics/last_used_for_user', user_id: user.id.to_s)
        expect(results).to eq []
      end
    end
  end

  context 'after getting authority on some topics' do
    it 'has those as last used topics' do
      as(user) do |pavlov|
        topic1 = pavlov.command(:'topics/create', title: 'Foo')
        topic2 = pavlov.command(:'topics/create', title: 'Bar')

        results = pavlov.query(:'user_topics/last_used_for_user', user_id: user.id.to_s)

        expected_results = [
          DeadUserTopic.new('foo', 'Foo', 11),
          DeadUserTopic.new('bar', 'Bar', 2)
        ]

        expect(results).to match_array []
      end
    end
  end
end
