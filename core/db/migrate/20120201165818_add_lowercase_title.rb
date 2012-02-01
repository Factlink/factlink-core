class AddLowercaseTitle < Mongoid::Migration
  def self.up
    say_with_time "adding lowercase title to channel" do
      Channel.all.each do |ch|
        ch.title = ch.title
        ch.save
      end
    end
    
  end

  def self.down
  end
end