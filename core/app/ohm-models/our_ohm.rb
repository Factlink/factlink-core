require 'ohm/contrib'

require_relative 'our_ohm/generic_reference'
require_relative 'our_ohm/value_reference'
require_relative 'our_ohm/monkey'
require_relative 'our_ohm/timestamped_set'

class OurOhm < Ohm::Model
  include Ohm::Contrib
  include Ohm::Callbacks
  include Ohm::Boundaries
  extend ActiveModel::Naming
  extend OurOhm::GenericReference
  extend OurOhm::ValueReference

  # needed for Ohm polymorphism:
  self.base = self

  class << self
    alias :create! :create
    alias :ohm_set :set
    alias :ohm_sorted_set :sorted_set

    def set(name,model)
      ohm_set(name, model)
      define_method(:"#{name}=") do |value|
        @_memo.delete(name)
        send(name).assign(value)
      end
    end

    def sorted_set(name,model, &block)
      ohm_sorted_set(name, model, &block)
      define_method(:"#{name}=") do |value|
        @_memo.delete(name)
        send(name).assign(value)
      end
    end
    def timestamped_set(name, model, &block)
      define_memoized_method(name) { Ohm::Model::TimestampedSet.new(key[name], Ohm::Model::Wrapper.wrap(model)) { |x| Ohm::Model::TimestampedSet.current_time } }
      define_method(:"#{name}=") do |value|
        @_memo.delete(name)
        send(name).assign(value)
      end
      collections(self) << name unless collections.include?(name)
    end
    def opinion_reference(name, &block)
      value_reference name, Opinion
      define_method(:"get_#{name}") do |*args|
        depth = args[0] || 0
        self.send(:"calculate_#{name}",depth) if depth > 0
        send(name) || Opinion.identity
      end
      define_method(:"calculate_#{name}") do |*args|
        depth = args[0] || 0
        send(:"#{name}=", (instance_exec depth, &block))
        save
      end
    end


  end

  def to_param
    id
  end

  def update_attributes!(attrs)
    self.update_attributes(attrs)
    valid = valid?

    save if valid

    valid
  end

  def encode_json(encoder)
    return self.to_json
  end

  alias save! save

  #needed for some rails compatibility
  alias :new_record? :new?

  def self.find_or_create_by(opts)
    self.find(opts).first || self.create(opts)
  end
end
