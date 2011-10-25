module Sites
  class Show < Mustache::Rails
    
    def as_json(options={})
      { :site => site, }
    end
  end
end