module SearchResults
  class SearchResultItem < Mustache::Railstache

    def the_class
      if self[:obj].class == "FactData"
        return Fact.to_s
      else
        return self[:obj].class.to_s
      end
    end

    def the_object
      klass = self[:obj].class

      if klass == FactData
        return Facts::Fact.for(fact: self[:obj].fact, view: self[:view])

      elsif klass == User
        return Users::User.for(user: self[:obj], view: self[:view])
      else
        raise "Error: SearchResults::SearchResultItem#the_object: No match on class."
      end
    end
  end
end