class CleanSortedFacts
  @queue = :janitor

  def self.perform(key_string)
    new(key_string).perform
  end

  def initialize(key_string)
    @key_string = key_string
  end

  def key
    @key ||= Ohm::Key.new(@key_string, Ohm.redis)
  end

  def perform
    key.zrevrangebyscore('inf', '-inf').each do |id|
      key.zrem(id) if Fact.invalid(Fact[id])
    end
  end
end
