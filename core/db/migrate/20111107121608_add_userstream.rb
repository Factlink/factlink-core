class AddUserstream < Mongoid::Migration
  def self.up
    GraphUser.all.each do |gu|
      gu.create_stream
    end
  end

  def self.down
  end
end