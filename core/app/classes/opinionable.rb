module Opinionable
  include Canivete::Deprecate

  
  def brain_cycles
    get_opinion.a.to_i
  end


end