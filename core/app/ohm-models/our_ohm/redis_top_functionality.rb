require 'active_support/concern'

class OurOhm
	module RedisTopFunctionality
    extend ActiveSupport::Concern
	  def reposition_in_top
	    interestingness = self.get_opinion().a
	    self.class.top_key.zadd(top_score, id)
	  end
	  def remove_from_top
	    self.class.top_key.zrem(id)
	  end
    module ClassMethods
  	  def cut_off_top
  	    top_key.zremrangebyrank(0,-20)
  	  end
  	  def top(nr=10)
  	    top_key.zrevrange(0,nr-1).map(&self)
  	  end
    end
	end
end