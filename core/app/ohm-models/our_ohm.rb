require_relative 'our_ohm/generic_reference'

class Ohm::Model
  def initialize(attrs = {})
    @id = nil
    @_memo ||= {}
    @_attributes ||= Hash.new { |hash, key| hash[key] = lazy_fetch(key) }
    super()
    update_local(attrs)
  end
end

class OurOhm < Ohm::Model
  extend ActiveModel::Naming
  extend OurOhm::GenericReference

  # needed for Ohm polymorphism:
  self.base = self

  def to_param
    id
  end

  def created_at_as_datetime
   parse_ohm_datetime created_at
  end

  alias save! save

  #needed for some rails compatibility
  alias :new_record? :new?

  protected
  def parse_ohm_datetime(str)
    DateTime.strptime str, '%Y-%m-%d %H:%M:%S %Z'
  end
end
