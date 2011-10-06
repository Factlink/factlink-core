class GraphUser < OurOhm
  set :beliefs_facts, Basefact
  set :believes_facts, Basefact
  set :doubts_facts, Basefact
  set :disbeliefs_facts, Basefact
  set :disbelieves_facts, Basefact
end

class GraphuserBeliefBelieve < Mongoid::Migration
  def self.up
    puts "moving facts"
    GraphUser.all.each do |gu|
      puts "changing #{gu}"
      gu.believes_facts = gu.beliefs_facts | gu.believes_facts
      gu.disbelieves_facts = gu.disbeliefs_facts | gu.disbelieves_facts
      gu.save
      gu.beliefs_facts.key.del
      gu.disbeliefs_facts.key.del
    end
  end

  def self.down
    raise "not possible"
  end
end