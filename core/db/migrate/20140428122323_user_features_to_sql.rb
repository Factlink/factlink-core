class UserFeaturesToSql < ActiveRecord::Migration
  def up
    User.all.each do |user|
      Nest.new('user')[user.id]['features'].smembers.each do |feature|
        user.features << Feature.create!(name: feature)
      end
      user.save!
    end

    Nest.new('admin_global_features').smembers.each do |feature|
      Feature.create!(name: feature)
    end
  end

  def down
  end
end
