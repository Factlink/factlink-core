class Opinion
  
  #naming conventions as in the document describing the calculations
  # b = belief
  # d = disbeliefs
  # u = is uncertain
  #
  # a = authority
  
  attr_accessor :b, :d, :u, :a
  
  def initialize(b,d,u,a=1)
    self.b=b
    self.d=d
    self.u=u
    self.a=a
  end

  def Opinion.for_type(type,authority=1)
    case type
    when :beliefs
      Opinion.new(1,0,0,authority)
    when :doubts
      Opinion.new(0,0,1,authority)
    when :disbeliefs
      Opinion.new(0,1,0,authority)
    end
  end
  
  
  def Opinion.combine(list)
    if list.length > 0
      Opinion.new(0,0,1)
    else
      a = list.inject(Opinion.new(0,0,0,0)) { |result, element |  result + element }
    end
  end
  
  def +(second)
    
    a = self.a + second.a
    
    if a == 0
      # No authority
      return Opinion.new(0,0,1)
    end
    
    b = (self.b*self.a + second.b*second.a)/a
    d = (self.d*self.a + second.d*second.a)/a
    u = (self.u*self.a + second.u*second.a)/a
    return Opinion.new(b,d,u,a)
  end
  
  #TODO : better name
  def dfa(fr,fl)
    result = self.discount_by(fr).discount_by(fl)
    result.a = min(fr.a,fl.a)
    return result
  end

  private
  def discount_by(fl)
    pu = self
        
    b = pu.b * fl.b
    d = pu.d * fl.b
    u = fl.d + fl.u + pu.u * fl.b
    return Opinion.new(b,d,u,a)
  end
        
end
