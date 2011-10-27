module Sites
  class Show < Mustache::Rails
    
    
    def to_hash
      { :site => site, }
    end
  end
end