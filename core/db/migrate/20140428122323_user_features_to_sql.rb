class UserFeaturesToSql < ActiveRecord::Migration
  def up
    User.all.each do |user|
      Nest.new('user')[user.id]['features'].smembers.each do |feature|
        user.features << Feature.create!(name: feature)
      end
      user.save!
    end
  end

  def down
  end
end
