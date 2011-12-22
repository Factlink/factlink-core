class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser
  
  generic_reference :subject
  generic_reference :object

  attribute :action
  
  def self.for(search_for)
    Activity::Query.for(search_for)
  end
end


class ChangeActivityBeliefBelieves < Mongoid::Migration
  def self.up
    say_with_time "Migrating beliefs to believes on Activities + the others" do
      Activity.all.each do |act|
        puts "changing #{act}"
        if act.action.to_sym == :beliefs
          act.action = :believes
          act.save
        elsif act.action.to_sym == :disbeliefs
          act.action = :disbelieves
          act.save
        end
      end
    end
  end

  def self.down
    raise "Not possible"
  end
end