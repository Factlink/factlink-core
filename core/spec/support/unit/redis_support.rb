module RedisSupport
  def number_of_commands_on redis, &block
    before = redis.info["total_commands_processed"].to_i
    block.call
    after =  redis.info["total_commands_processed"].to_i

    # subtract one more, because the info command itself is counted as well
    after - before - 1
  end
end
