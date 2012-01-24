class RemovePaperclipAvatarFields < Mongoid::Migration
  def self.up
    say_with_time "Removing the avatar fields created by Mongoid Paperclip" do
      User.all.each do |user|
        user.unset(:avatar_content_type)
        user.unset(:avatar_file_name)
        user.unset(:avatar_file_size)
        user.unset(:avatar_updated_at)
      end
    end
  end

  def self.down
  end
end