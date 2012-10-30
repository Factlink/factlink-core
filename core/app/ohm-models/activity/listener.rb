require 'active_support/core_ext/hash/slice'

class Activity < OurOhm
  class Listener

    def self.all
      @all ||= {}
      @all
    end

    attr_accessor :activity_for, :listname, :queries

    def self.register &block
      a = new &block
      @all ||= {}
      @all[{class: a.activity_for, list: a.listname}] = a
    end

    def self.reset
      @all = {}
    end

    def initialize(&block)
      self.queries = []
      Dsl.new self, &block if block_given?
    end

    def add_to activity
      res = []
      self.queries.each do |query|
        if matches(query, activity)
          res += query[:write_ids].call(activity)
        end
      end
      res
    end

    def matches query, activity
      fields_to_match = :subject_class, :object_class, :action
      return false if query.slice(:extra_condition, *fields_to_match) == {}
      extra_keys = query.keys - query.slice(:extra_condition, :write_ids, *fields_to_match).keys
      raise Exception.exception("Extra keys: #{extra_keys}") if extra_keys != []

      field_query = query.slice *fields_to_match
      field_query.each_pair do |field, value|
        real = activity.send(field)
        if value.respond_to? :map
          return false unless value.map(&:to_s).include? real.to_s
        else
          return false unless real.to_s == value.to_s
        end
      end

      if query[:extra_condition]
        query[:extra_condition].call(activity)
      else
        return true
      end
    end

    def process activity
      add_to(activity).each do |id|
                                     #constantize
        klass = self.activity_for.split('::').inject(Kernel) {|x,y|x.const_get(y)}
        instance = klass[id]
        activity.add_to_list_with_score(instance.send(listname)) if instance
      end
    end

    class Dsl
      def initialize(listener,&block)
        @listener = listener
        execute &block if block_given?
      end

      def execute &block
        instance_eval &block
      end

      def activity_for klass
        @listener.activity_for= klass
      end

      def named name
        @listener.listname = name
      end

      def activity activity_description
        @listener.queries << activity_description
      end
    end
  end
end
