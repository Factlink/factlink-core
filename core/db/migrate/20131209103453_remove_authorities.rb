class RemoveAuthorities < Mongoid::Migration
  def self.up
    Resque.enqueue MigrateRemoveAuthoritiesWorker
  end

  def self.down
  end
end
