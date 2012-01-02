
class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser

  generic_reference :subject
  generic_reference :object

  attribute :action
  index     :action
end


class AddActionIndexToActivities < Mongoid::Migration
  def self.up
    say_with_time "Saving all activities again to make sure the action index exists" do
      Activity.all.each do |a|
        a.save
      end
    end

  end

  def self.down
  end
end