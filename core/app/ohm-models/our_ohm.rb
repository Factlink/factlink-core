require 'ohm/contrib'

module OhmGenericReference
  def generic_reference(name)
    reader = :"#{name}_id"
    writer = :"#{name}_id="

    reader_c = :"#{name}_class"
    writer_c = :"#{name}_class="

    attributes(self) << reader   unless attributes.include?(reader)
    attributes(self) << reader_c unless attributes.include?(reader_c)

    index reader
    index reader_c

    define_memoized_method(name) do
      klass = Kernel.const_get(send(reader_c))
      id = send(reader)
      if klass == NilClass
        nil
      else
        klass[id]
      end
    end

    define_method(:"#{name}=") do |value|
      @_memo.delete(name)
      send(writer, value ? value.id : nil)
      send(writer_c, value ? value.class : nil)
    end

    define_method(reader) do
      read_local(reader)
    end

    define_method(writer) do |value|
      @_memo.delete(name)
      write_local(reader, value)
    end

    define_method(reader_c) do
      read_local(reader_c)
    end

    define_method(writer_c) do |value|
      @_memo.delete(name)
      write_local(reader_c, value)
    end
  end
end 

class OurOhm < Ohm::Model
  include Ohm::Contrib
  include Ohm::Callbacks
  include Ohm::Boundaries
  extend ActiveModel::Naming
  extend OhmGenericReference
  include Canivete::Deprecate

  # needed for Ohm polymorphism:
  self.base = self

  class << self
    alias :create! :create
  end


  alias save! save

  deprecate
  alias :new_record? :new?

  def self.find_or_create_by(opts)
    self.find(opts).first || self.create(opts)
  end


end

class Ohm::Model::Set < Ohm::Model::Collection
  alias :count :size

  def &(other)
    apply(:sinterstore,key,other.key,key+"*INTERSECT*"+other.key)
  end

  def |(other)
    apply(:sunionstore,key,other.key,key+"*UNION*"+other.key)
  end

  def -(other)
    apply(:sdiffstore,key,other.key,key+"*DIFF*"+other.key)
  end

end

class Ohm::Model::List < Ohm::Model::Collection
  alias :count :size
end