require 'spec_helper'

describe "credibility calculation of facts*users" do
  def recalculate_credibility
    nr = number_of_commands_on Ohm.redis do
      MapReduce::FactCredibility.new.process_all
      MapReduce::FactRelationCredibility.new.process_all
    end
    puts "Number of redis commands: #{nr}"
  end

  it "should be fast" do
    channels = (0..10).map {|i| create(:channel, created_by: u1)}
    facts = (0..100).map {|i| create(:fact)}

    channels.each do |channel|
      Authority.from(channel.topic, for: u1) << 10.0
      facts.each do |fact|
        interactor = Interactors::Channels::AddFact.new fact, channel, no_current_user: true
        interactor.call
      end
    end

    (0..95).each do |i|
      (0..5).each do |j|
        facts[i].add_evidence(:supporting, facts[i+j], u1)
      end
    end

    recalculate_credibility
  end
end
