class RemoveInvalidActivities < ActiveRecord::Migration
  def up
    Activity.all.each do |a|
      unless a.valid? && a.subject && a.user && !a.user.deleted
        a.destroy
      end
    end
  end

  def down
  end
end
