class RemoveFactGraphOpinions < Mongoid::Migration
  def self.up
    Resque.enqueue RemoveFactGraphOpinionsWorker
  end

  def self.down
  end
end
