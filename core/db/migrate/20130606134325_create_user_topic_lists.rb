class CreateUserTopicLists < Mongoid::Migration
  def self.up
    say_with_time("Creating UserTopic lists for users") do
      Topic.all.each do |topic|
        Authority.all_from(topic).each do |auth|
          graph_user_id = auth.user_id
          authority = auth.to_f

          Resque.enqueue Commands::Topics::UpdateUserAuthority,
             graph_user_id, topic.slug_title, authority
        end
      end
    end
  end

  def self.down
  end
end
