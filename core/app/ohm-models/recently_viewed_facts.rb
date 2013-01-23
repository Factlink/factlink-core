class RecentlyViewedFacts
  def self.current_time(time=nil)
    time ||= DateTime.now
    (time.to_time.to_f*1000).to_i
  end

  def self.by_user_id(id, nest_key=Nest.new(:recently_viewed_facts))
    new nest_key[:user][id]
  end

  attr_reader :nest_key

  def initialize nest_key
    @nest_key = nest_key
  end

  def top count
    top_ids(count).map {|id| Fact[id]}
                  .compact
  end

  def add_fact_id id
    nest_key.zadd self.class.current_time, id
  end

  def truncate keep_count
    nest_key.zremrangebyrank 0, -keep_count-1
  end

  private
  def top_ids count
    nest_key.zrevrange 0, count-1
  end
end
