require 'spec_helper'

def add_channel usser, name
  channel = Channel.new title: name
  channel.created_by =  user.graph_user
  channel.save
end

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
        channel.add_fact(fact)
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
