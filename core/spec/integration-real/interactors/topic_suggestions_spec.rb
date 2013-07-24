require 'spec_helper'

describe 'suggested_topics' do
  include PavlovSupport

  let(:user) { create :user }

  describe 'initially' do
    it 'a site has no top topics' do
      as(user) do |pavlov|
        url = 'http://google.com/'
        site = pavlov.old_command :'sites/create', url

        topics = pavlov.old_interactor :'site/top_topics', url, 10

        expect(topics).to eq []
      end
    end
  end

  describe 'counting top topics' do
    it 'registers the calls to the command' do
      as(user) do |pavlov|
        url = 'http://google.com/'
        site = pavlov.old_command :'sites/create', url

        topic_slug_array = [
          'some-topic', 'some-other-topic', 'some-topic', 'beren',
          'some-topic'
        ]

        topic_slug_array.each do |topic_slug|
          pavlov.old_command :'site/add_top_topic', site.id.to_i, topic_slug
          begin
            create :topic, slug_title: topic_slug, title: topic_slug.capitalize
          rescue
          end
        end
        topics = pavlov.old_interactor :'site/top_topics', url, 1
        expect(topics.map(&:slug_title)).to eq ['some-topic']
      end
    end
  end

  describe 'are returned' do
    it 'in the correct order' do
      as(user) do |pavlov|
        url = 'http://google.com/'
        site = pavlov.old_command :'sites/create', url

        fact1 = create :fact, site: site
        fact2 = create :fact, site: site

        top_suggestion   = pavlov.old_command :'channels/create', 'top-suggestion'
        loser_suggestion = pavlov.old_command :'channels/create', 'loser-suggestion'

        pavlov.old_interactor  :'channels/add_fact', fact1, top_suggestion
        pavlov.old_interactor  :'channels/add_fact', fact1, loser_suggestion
        pavlov.old_interactor  :'channels/add_fact', fact2, top_suggestion

        topics = pavlov.old_interactor :'site/top_topics', url, 2

        expect(topics[0].slug_title).to eq top_suggestion.slug_title
        expect(topics[1].slug_title).to eq loser_suggestion.slug_title
      end
    end
  end

end
