class Ohm::Model::TimestampedSet < Ohm::Model::SortedSet
  def self.current_time(time=nil)
    time ||= DateTime.now
    (time.to_time.to_f*1000).to_i
  end
  def initialize(*args)
    super(*args) do |f|
      self.class.current_time
    end
  end

  def unread_count
    last_read = key['last_read'].get
    if last_read
      key.zcount(last_read,'+inf')
    else
      key.zcard
    end
  end

  def mark_as_read
    key['last_read'].set(self.class.current_time)
  end

  alias :until :below

  def inspect
    "#<TimestampedSet (#{model}): #{key.zrange(0,-1).inspect}>"
  end

end
