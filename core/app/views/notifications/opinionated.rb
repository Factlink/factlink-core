module Notifications
  class Opinionated < Mustache::Railstache

    def action
      self[:activity].action
    end

    def translated_action
      return case action.to_sym
      when :believes
        t(:fact_believe_past_action)
      when :disbelieves
        t(:fact_disbelieve_past_action)
      when :doubts
        t(:fact_doubt_past_action)
      else
        ""
      end
    end

    def fact_path
      if self[:activity].subject.class.to_s == "Fact"
        friendly_fact_path self[:activity].subject
      elsif self[:activity].subject.class.to_s == "FactRelation"
        friendly_fact_path self[:activity].subject.from_fact
      end
    end

    def subject
      if self[:activity].subject.class.to_s == "Fact"
        return truncate("#{self[:activity].subject}", length: 85, separator: ' ')
      elsif self[:activity].subject.class.to_s == "FactRelation"
        return truncate("#{self[:activity].subject.from_fact}", length: 85, separator: ' ')
      end
    end

  end
end