class Opinion < OurOhm
  
  # naming conventions as in the document describing the calculations
  # b = belief
  # d = disbeliefs
  # u = uncertain
  #
  # a = authority
  #
  # _r in redis
  
  attribute :b_r
  attribute :d_r
  attribute :u_r
  attribute :a_r
  
  def b
    self.b_r.to_f
  end
  def d
    self.d_r.to_f
  end
  def u
    self.u_r.to_f
  end
  def a
    self.a_r.to_f
  end
  def b=(val)
    self.b_r=val
  end
  def d=(val)
    self.d_r=val
  end
  def u=(val)
    self.u_r=val
  end
  def a=(val)
    self.a_r=val
  end
  
  def self.neew(b,d,u,a=0)
    self.new(:b_r=>b,:d_r=>d,:u_r=>u,:a_r=>a)
  end

  def self.identity
    self.new(:b_r=>0,:d_r=>0,:u_r=>0,:a_r=>0)
  end


  def Opinion.for_type(type, authority=0)
    case type
    when :beliefs
      Opinion.neew(1,0,0,authority)
    when :disbeliefs
      Opinion.neew(0,1,0,authority)
    when :doubts
      Opinion.neew(0,0,1,authority)
    end
  end
  
  # inefficient, but allows for quickly changing the + def
  def Opinion.combine(list)
    unless list.length > 0
      Opinion.neew(0,0,0)
    else
      a = list.inject(Opinion.neew(0,0,0,0)) { | result, element |  result + element }
    end
  end

  #CHANGE ALONG WITH + !!!!
  def weight
    return (self.b + self.d + self.u)*self.a
  end

  #CHANGE weight ALONG WITH + !!!
  def +(second)
    a = self.a + second.a
    
    if a == 0
      # No authority
      return Opinion.neew(0.1,0.1,0.1)
    end
    
    b = (self.b*self.a + second.b*second.a)/a
    d = (self.d*self.a + second.d*second.a)/a
    u = (self.u*self.a + second.u*second.a)/a
    return Opinion.neew(b,d,u,a)
  end

  
  #TODO : better name
  def dfa(fr,fl)
    result = self.discount_by(fr).discount_by(fl)

    result.a = [fr.a, fl.a].min
    return result
  end
  
  def ==(other)
    self.a == other.a and
      self.b == other.b and
      self.d == other.d and
      self.u == other.u
  end

  protected
  def discount_by(fl)
    pu = self
        
    b = pu.b * fl.b
    d = pu.d * fl.b
    u = fl.d + fl.u + pu.u * fl.b
    return Opinion.neew(b,d,u,a)
  end
        
end
