class GraphusersNotUsers < Mongoid::Migration
  def self.up
    say_with_time "Change users to graphusers for erroneous activities" do
      Activity.all.each do |a|
        if a.user.nil?
          if u = User.find(a.user_id)
            a.user = u.graph_user
            a.save
          else
            a.delete
          end
        end
      end
    end
  end

  def self.down
  end
end