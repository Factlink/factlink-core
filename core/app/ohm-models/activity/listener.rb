require 'active_support/core_ext/hash/slice'

class Activity < OurOhm
  class Listener
    require_relative 'listener/stream'

    def self.all
      @all ||= {}
      @all
    end

    attr_accessor :activity_for, :listname, :queries

    def self.register &block
      a = new &block
      register_listener a
    end

    def self.register_listener a
      @all ||= {}
      @all[{class: a.activity_for, list: a.listname}] ||= []
      @all[{class: a.activity_for, list: a.listname}] << a
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

    def matches_any? activity
      queries.each do |query|
        return true if matches(query, activity)
      end
      return false
    end

    def matches query, activity
      field_query = get_fields_query(query)
      return false if field_query == {} and
                      query[:extra_condition].nil?

      extra_condition = query.fetch(:extra_condition) do |variable|
        ->(a) {true}
      end

      field_query.each_pair do |field, value|
        actual_value = activity.send(field).to_s
        allowed_values = Array(value).map(&:to_s)
        return false unless allowed_values.include? actual_value
      end

      extra_condition.call(activity)
    end

    def get_fields_query query
      fields_to_match = :subject_class, :object_class, :action
      fields_query = query.slice(*fields_to_match)

      extra_keys = query.keys -
                   fields_query.keys -
                   [:extra_condition, :write_ids]
      raise Exception.exception("Extra keys: #{extra_keys}") if extra_keys != []

      fields_query
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
