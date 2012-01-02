class Basefact < OurOhm
  set :people_beliefs, GraphUser
  set :people_believes, GraphUser
  set :people_doubts, GraphUser
  set :people_disbeliefs, GraphUser
  set :people_disbelieves, GraphUser
end

class BasefactBeliefBelieve < Mongoid::Migration
  def self.up
    say_with_time "moving people" do
      Basefact.all.each do |bf|
        puts "changing #{bf}"
        bf.people_believes = bf.people_beliefs | bf.people_believes
        bf.people_disbelieves = bf.people_disbeliefs | bf.people_disbelieves
        bf.save
        bf.people_beliefs.key.del
        bf.people_disbeliefs.key.del
      end
    end
  end

  def self.down
    raise "not possible"
  end
end