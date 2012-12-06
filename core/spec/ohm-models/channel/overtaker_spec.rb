require 'ohm_helper'

require 'active_support/core_ext/module/delegation'
require_relative '../../../app/ohm-models/activity.rb'
require_relative '../../../app/ohm-models/channel.rb'

class Basefact < OurOhm;end
class Fact < Basefact;end
class GraphUser < OurOhm;end

def create_fact
  FactoryGirl.create :fact
rescue
  Fact.create
end

def create_channel(opts={})
  ch = Channel.create(opts)
  ch.singleton_class.send :include, Channel::Overtaker
  ch
end

def add_fact_to_channel(fact, channel)
  interactor = Interactors::Channels::AddFact.new fact, channel, no_current_user: true
  interactor.execute
end

describe Channel::Overtaker do

  let(:ch1) {create_channel :created_by => u1, :title => "Something" }
  let(:ch2) {create_channel :created_by => u1, :title => "Diddly"}

  let(:subch1) {create_channel :created_by => u1, :title => "Sub"}

  let(:u1) { GraphUser.create }
  let(:u2) { GraphUser.create }

  let (:f1) { create_fact }
  let (:f2) { create_fact }
  let (:f3) { create_fact }
  let (:f4) { create_fact }

  before do
    Fact.stub(:invalid,false)
  end


  describe :take_over do
    it "should move all internal facts" do
      add_fact_to_channel f1, ch1
      add_fact_to_channel f2, ch2
      ch1.take_over(ch2)
      ch1.facts.should =~ [f1,f2]
    end
    it "should move all deleted facts" do
      add_fact_to_channel f1, ch1
      ch2.remove_fact f1
      ch1.take_over(ch2)
      ch1.facts.should =~ []
    end
    it "should take over contained_channels" do
      ch2.add_channel subch1
      ch1.take_over ch2
      ch1.contained_channels.all.should =~ [subch1]
      subch1.containing_channels.all.should =~ [ch1,ch2]
    end
  end
end
