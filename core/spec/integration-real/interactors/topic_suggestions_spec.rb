require 'spec_helper'

describe 'suggested_topics' do
  include Pavlov::Helpers

  let(:current_user) { create :user }

  def pavlov_options
    {current_user: current_user}
  end

  describe 'initially' do
    it 'a site has no top topics' do
      s = create :site

      topics = query :'site/top_topics', s.id.to_i, 10

      expect(topics).to eq []
    end
  end

  describe 'counting top topics' do
    it 'registers the calls to the command' do
      site = create :site

      topic_slug_array = [
        'some-topic', 'some-other-topic', 'some-topic', 'beren',
        'some-topic'
      ]

      topic_slug_array.each do |topic_slug|
        command :'site/add_top_topic', site.id.to_i, topic_slug
        begin
          create :topic, slug_title: topic_slug, title: topic_slug.capitalize
        rescue
        end
      end
      topics = query :'site/top_topics', site.id.to_i, 1
      expect(topics.map(&:slug_title)).to eq ['some-topic']
    end
  end

  describe 'resetting top topic' do
    it 'counts the topic slugs' do
      site = create :site

      facts = create_list :fact, 3

      facts.each do |fact|
        fact.channels << create(:channel, title: 'henk')
        fact.channels << create(:channel, title: 'klaas')
      end

      facts[0].channels << create(:channel, title: 'geert')
      facts[1].channels << create(:channel, title: 'harrie')
      facts[2].channels << create(:channel, title: 'gerrie')

      site.facts << facts[0]
      site.facts << facts[1]
      site.facts << facts[2]

      command :'site/reset_top_topics', site.id.to_i
      topics = query :'site/top_topics', site.id.to_i, 2
      expect(topics.map(&:slug_title)).to match_array ['henk', 'klaas']
    end
  end

  describe 'are returned' do
    it 'in the correct order' do
      site = create :site

      fact1 = create :fact
      fact2 = create :fact

      top_suggestion   = create(:channel, title: 'top-suggestion')
      loser_suggestion = create(:channel, title: 'loser-suggestion')

      fact1.channels << top_suggestion
      fact1.channels << loser_suggestion

      fact2.channels << top_suggestion

      site.facts << fact1
      site.facts << fact2

      command :'site/reset_top_topics', site.id.to_i
      topics = query :'site/top_topics', site.id.to_i, 2

      expect(topics[0].slug_title).to eq top_suggestion.slug_title
      expect(topics[1].slug_title).to eq loser_suggestion.slug_title


      fact3 = create :fact
      fact4 = create :fact
      fact5 = create :fact

      fact3.channels << loser_suggestion
      fact4.channels << loser_suggestion
      fact5.channels << loser_suggestion

      site.facts << fact3
      site.facts << fact4
      site.facts << fact5

      command :'site/reset_top_topics', site.id.to_i
      topics = query :'site/top_topics', site.id.to_i, 2

      expect(topics[0].slug_title).to eq loser_suggestion.slug_title
      expect(topics[1].slug_title).to eq top_suggestion.slug_title
    end
  end

end
