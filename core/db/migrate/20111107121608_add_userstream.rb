class GraphUser < OurOhm
  reference :stream, UserStream
  def create_stream
    self.stream = UserStream.create(:created_by => self)
    save
  end
end

class AddUserstream < Mongoid::Migration
  def self.up
    GraphUser.all.each do |gu|
      gu.create_stream
    end
  end

  def self.down
  end
end