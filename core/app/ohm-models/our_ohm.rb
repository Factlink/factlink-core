require 'ohm/contrib'

require_relative 'our_ohm/generic_reference'
require_relative 'our_ohm/monkey'
require_relative 'our_ohm/timestamped_set'

class OurOhm < Ohm::Model
  extend ActiveModel::Naming
  extend OurOhm::GenericReference

  # needed for Ohm polymorphism:
  self.base = self

  class << self
    def set(name,model)
      super
      define_method(:"#{name}=") do |value|
        @_memo.delete(name)
        send(name).assign(value)
      end
    end

    def sorted_set(name,model, &block)
      super
      define_method(:"#{name}=") do |value|
        @_memo.delete(name)
        send(name).assign(value)
      end
    end

    def timestamped_set(name, model, &block)
      define_memoized_method(name) do
         Ohm::Model::TimestampedSet.new(key[name], Ohm::Model::Wrapper.wrap(model)) do |x|
           Ohm::Model::TimestampedSet.current_time
         end
      end
      define_method(:"#{name}=") do |value|
        @_memo.delete(name)
        send(name).assign(value)
      end
      collections(self) << name unless collections.include?(name)
    end
  end

  def to_param
    id
  end

  def created_at_as_datetime
   parse_ohm_datetime self.created_at
  end

  alias save! save

  #needed for some rails compatibility
  alias :new_record? :new?

  protected
  def parse_ohm_datetime(str)
    DateTime.strptime str, '%Y-%m-%d %H:%M:%S %Z'
  end
end
