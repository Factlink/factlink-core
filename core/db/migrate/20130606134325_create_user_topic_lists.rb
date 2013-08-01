class CreateUserTopicLists < Mongoid::Migration
  def self.up
    say_with_time("Creating UserTopic lists for users") do
      Topic.all.each do |topic|
        Authority.all_from(topic).each do |auth|
          graph_user_id = auth.user_id
          authority = auth.to_f

          Resque.enqueue(Commands::Topics::UpdateUserAuthority, {
            graph_user_id: graph_user_id, topic_slug: topic.slug_title,
            authority: authority })
        end
      end
    end
  end

  def self.down
  end
end
