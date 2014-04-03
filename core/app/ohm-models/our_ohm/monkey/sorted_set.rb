class Ohm::Model::SortedSet < Ohm::Model::Collection
  extend RedisUtils

  alias :count :size

  def assign(set)
    apply(key,:zunionstore,[set.key],{:aggregate => :max})
  end

  def below(limit,opts={})
    if opts[:count]
      redis_opts = { limit: [0, opts[:count]] }
    else
      redis_opts = {}
    end

    redis_opts[:withscores] = opts[:withscores]

    res = key.zrevrangebyscore("(#{limit}", '-inf', redis_opts)

    if opts[:withscores]
      res = self.class.hash_array_for_withscores(res).map { |x| { item: model[x[:item]], score: x[:score] } }
    else
      res = res.map { |x| model[x] }
    end
    opts[:reversed]? res : res.reverse
  end

  def ids
    key.zrange(0, -1)
  end

  protected
    # @private
    def apply(target,operation,*args)
      target.send(operation,*args)
      self.class.new(target,Ohm::Model::Wrapper.wrap(model),&@score_calculator)
    end

end
