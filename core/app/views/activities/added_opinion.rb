module Activities
  class AddedOpinion < Mustache::Railstache

    def fact
      Facts::Fact.for(fact: self[:activity].subject, view: self[:view])
    end

  end
end
