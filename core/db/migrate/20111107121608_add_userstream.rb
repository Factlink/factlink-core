class GraphUser < OurOhm
  reference :stream, ::Channel::UserStream
  def create_stream
    self.stream = ::Channel::UserStream.create(:created_by => self)
    save
  end
end

class AddUserstream < Mongoid::Migration
  def self.up
    say_with_time "add a userstream (all channel) for all graphusers" do
      GraphUser.all.each do |gu|
        gu.create_stream
      end
    end
  end

  def self.down
  end
end
