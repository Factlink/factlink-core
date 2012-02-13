module Activities
  class Opinionated < Mustache::Railstache

    def action
      self[:activity].action
    end

    def subject
      if self[:activity].subject.class.to_s == "Fact"
        return "#{self[:activity].subject}"
      elsif self[:activity].subject.class.to_s == "FactRelation"
        return "#{self[:activity].subject.from_fact}"
      end
    end

  end
end