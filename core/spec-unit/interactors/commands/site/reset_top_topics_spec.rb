require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/site/reset_top_topics.rb'

describe Commands::Site::ResetTopTopics do
  include PavlovSupport

  describe 'validations' do
    let(:subject_class) { Commands::Site::ResetTopTopics }

    it 'requires arguments' do
      expect_validating('11ee').
        to fail_validation('site_id should be an integer.')
    end
  end

  describe '.execute' do

    it 'resets the score for all topics' do
      site_id = 91
      score_hash = { 'foo' => 17, 'bar' => 2 }

      command = Commands::Site::ResetTopTopics.new site_id

      command.should_receive(:clear_topics)
      command.stub scores: score_hash
      score_hash.each do |key, value|
        command.should_receive(:increase_topic_by).with(key, value)
      end
      command.execute
    end
  end

  describe '.clear_topics' do
    it 'should delete the redis key' do
      site_id = 91

      command = Commands::Site::ResetTopTopics.new site_id

      key = mock
      command.stub key: key
      key.should_receive(:del)

      command.clear_topics
    end
  end

  describe '.scores' do
    it 'should receive the score hashes for each fact and merge them' do
      site_id = 91
      facts = [mock, mock]
      fact_scores = [mock, mock]
      result = mock

      command = Commands::Site::ResetTopTopics.new site_id

      command.stub facts: facts
      facts.each_with_index do |fact, index|
        command.should_receive(:scores_for_fact).with(fact).and_return(fact_scores[index])
      end

      command.should_receive(:sum_hashes).with(fact_scores).and_return(result)
      expect(command.scores).to eq result

    end
  end

  describe '.scores_for_fact' do
    it "returns a hash with the topic count for the fact" do
      site_id = 91
      fact = mock
      slugs = mock
      result = mock

      command = Commands::Site::ResetTopTopics.new site_id
      command.should_receive(:slugs_for_fact).with(fact).and_return(slugs)
      command.should_receive(:score_hash_for_array).with(slugs).and_return(result)

      expect(command.scores_for_fact(fact)).to eq result
    end
  end

  describe '.facts' do
    it "should find all fact linked to the site with site_id" do
      stub_classes "Fact"
      site_id = 91
      facts = mock

      command = Commands::Site::ResetTopTopics.new site_id

      Fact.should_receive(:find).with(site_id: site_id).and_return(facts)

      expect(command.facts).to eq facts
    end
  end

  describe '.sum_hashes' do
    let (:command) { Commands::Site::ResetTopTopics.new 15 }
    it 'should return a empty hash for an empty array' do
      expect( command.sum_hashes([])).to eq({})
    end

    it 'returns an identical hash when receiving one hash' do
      hash = { 2 => 2 }
      hashes = [hash]

      expect( command.sum_hashes(hashes)).to eq hash
    end

    it 'returns a summed hash when receiving multiple hashes' do
      hash1 = { 2 => 1 }
      hash2 = { 2 => 1, 3 => 3 }
      hash3 = { 1 => 1}
      hashes = [hash1, hash2, hash3]

      summed_hash = { 1 => 1, 2 => 2, 3 => 3 }

      expect( command.sum_hashes(hashes)).to eq summed_hash
    end
  end

  describe '.slugs_for_fact' do
    let (:command) { Commands::Site::ResetTopTopics.new 15 }
    it 'returns all channels slugs for this fact' do
      channels = [
        mock(slug_title: 'gerard'),
        mock(slug_title: 'henk'),
        mock(slug_title: nil),
        mock(slug_title: 'frans'),
      ]
      fact = stub channels: channels

      expect(command.slugs_for_fact(fact)).to eq ['gerard','henk','frans']
    end
  end

  describe '.score_hash_for_array' do
    let (:command) { Commands::Site::ResetTopTopics.new 15 }
    it 'should return an empty hash for an empty array' do
      expect( command.score_hash_for_array([])).to eq({})
    end

    it 'should return a count for a non-empty array' do
      array = [1, 2, 2, 3, 3, 3]
      hash = { 1 => 1, 2 => 2, 3 => 3 }

      expect( command.score_hash_for_array(array)).to eq hash
    end
  end

end
