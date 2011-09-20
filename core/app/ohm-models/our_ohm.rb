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

module OhmValueReference
  def value_reference(name, model)
    model = Ohm::Model::Wrapper.wrap(model)
    reader = :"#{name}_id"
    writer = :"#{name}_id="

    attributes(self) << reader   unless attributes.include?(reader)

    define_memoized_method(name) do
      model.unwrap[send(reader)]
    end

    define_method(:"#{name}=") do |value|
      cur_val = send("#{name}")
      if cur_val
        unless cur_val == value
          cur_val.take_values(value)
        end
      else
        @_memo.delete(name)
        value.save
        send(writer, value ? value.id : nil)
      end
    end

    define_method(reader) do
      read_local(reader)
    end

    define_method(writer) do |value|
      @_memo.delete(name)
      write_local(reader, value)
    end

  end
end 


class OurOhm < Ohm::Model
  include Ohm::Contrib
  include Ohm::Callbacks
  include Ohm::Boundaries
  extend ActiveModel::Naming
  extend OhmGenericReference
  extend OhmValueReference
  include Canivete::Deprecate

  # needed for Ohm polymorphism:
  self.base = self

  class << self
    alias :create! :create
  end
  def self.set(name,model)
    self.superclass.set(name, model)
    define_method(:"#{name}=") do |value|
      @_memo.delete(name)
      send(name).assign(value)
      value.key.sunionstore(key[name]) #copy
    end
  end


  alias save! save

  #needed for some rails compatibility
  alias :new_record? :new?

  def self.find_or_create_by(opts)
    self.find(opts).first || self.create(opts)
  end


end

# TODO refactor ohm so this works  lazy  and efficiently does the def the | and the -
class Ohm::Model::Set < Ohm::Model::Collection
  alias :count :size

  def assign(set)
    apply(:sunionstore,set.key,set.key,key) #copy; dirty stupid code, sorry
  end

  def &(other)
    apply(:sinterstore,key,other.key,key+"*INTERSECT*"+other.key)
  end

  def |(other)
    apply(:sunionstore,key,other.key,key+"*UNION*"+other.key)
  end

  def -(other)
    apply(:sdiffstore,key,other.key,key+"*DIFF*"+other.key)
  end

  def random_member()
    model.to_proc[key.srandmember]
  end

end

class Ohm::Model::List < Ohm::Model::Collection
  alias :count :size
end