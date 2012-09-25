class CreateElasticSearchIndexForUsers < Mongoid::Migration
  def self.up
    say_with_time "Preparing to index ElasticSearch for all Users" do
      User.all.each do |user|
        Resque.enqueue(CreateSearchIndexForUser, user.id)
      end
    end

  end

  def self.down
  end
end
