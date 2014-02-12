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

  alias :until :below

  def inspect
    "#<TimestampedSet (#{model}): #{key.zrange(0,-1).inspect}>"
  end

end
