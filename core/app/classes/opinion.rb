class Opinion
  
  #naming conventions as in the document describing the calculations
  # b = belief
  # d = disbeliefs
  # u = is uncertain
  # a = authority
  
  #attr_accessor :a
  
  def initialize(b,d,u,a=1)
    @b=b
    @d=d
    @u=u
    @a=a
  end
  
  def Opinion.combine_opinions(list)
    if list.length > 0
      Opinion.new(0,0,1)
    else
      a = list.inject(Opinion.new(0,0,0,0)) { |result, element |  result + element }
    end
  end
  
  def +(second)
    a = self.a + second.a
    
    b = (self.b*self.a + second.b*second.a)/a
    d = (self.d*self.a + second.d*second.a)/a
    u = (self.u*self.a + second.u*second.a)/a
    return Opinion.new(b,d,u,a)
  end
  
  
  def _filter_with(fr)
    pu = self
    
    b = pu.b * fr.b
    d = pu.d * fr.b
    u = fr.d + fr.u + pu.u * fr.b
    return Opinion.new(b,d,u,a)
  end
  
  def _discount_by(fl)
    pu = self
        
    b = pu.b * fl.b
    d = pu.d * fl.b
    u = fl.d + fl.u + pu.u * fl.b
    return Opinion.new(b,d,u,a)
  end
  
  #TODO : better name
  def dfa(fr,fl)
    result = self._filter_with(fr)._discount_by(fl)
    result.a = min(fr.a,fl.a)
    return result
  end
        
end