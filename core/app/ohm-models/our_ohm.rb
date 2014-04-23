require_relative 'our_ohm/generic_reference'

class OurOhm < Ohm::Model
  extend ActiveModel::Naming
  extend OurOhm::GenericReference

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
