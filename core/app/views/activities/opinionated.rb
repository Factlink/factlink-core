module Activities
  class Opinionated < Mustache::Railstache

    def action
      self[:activity].action
    end

    def subject
      if self[:activity].subject.class.to_s == "Fact"
        return "#{self[:activity].subject}"
      elsif self[:activity].subject.class.to_s == "FactRelation"
        return "the relation between \"#{self[:activity].subject.from_fact}\" and \"#{self[:activity].subject.fact}\""
      else
        return "no idea"
      end
    end

  end
end