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
      classname = send(reader_c)
      id = send(reader)

      next nil unless classname && id

              #constantize:
      klass = classname.split('::').inject(Kernel) {|x,y|x.const_get(y)}
      if klass == NilClass
        nil
      else
        klass[id]
      end
    end

    define_method(:"#{name}=") do |value|
      @_memo.delete(name)
      send(writer, value ? value.id : nil)
      send(writer_c, value ? value.class.to_s : nil)
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


  def belief_check(type)
    type = type.to_sym
    if [:beliefs,:disbeliefs].include?(type)
      #warn "please fix the spelling of your #{type}"
    end
  end

end

# TODO refactor ohm so this works  lazy  and efficiently does the def the | and the -
class Ohm::Model::Set < Ohm::Model::Collection
  alias :count :size

  def ids
    key.smembers
  end

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


class Ohm::Model::SortedSet < Ohm::Model::Collection
  alias :count :size

  def assign(set)
    apply(key,:zunionstore,[set.key],{:aggregate => :max})
  end

  def &(other)
    apply(key+"*INTERSECT*"+other.key,:zinterstore,[key,other.key],{:aggregate => :max})
  end

  def |(other)
    apply(key+"*UNION*"+other.key,:zunionstore,[key,other.key],{:aggregate => :max})
  end

  def -(other)
    result_key = key + "*DIFF*" + other.key
    result = apply(result_key,:zunionstore,[key],{:aggregate => :max})
    other.each do |item| # do this efficienter later
      result.delete(item)
    end
    result
  end

  def all_reversed
    key.zrevrange(0,-1).map(&model)
  end


  protected
    # @private
    def apply(target,operation,*args)
      target.send(operation,*args)
      self.class.new(target,Ohm::Model::Wrapper.wrap(model),&@score_calculator)
    end   

end

class Ohm::Model::TimestampedSet < Ohm::Model::SortedSet
  def self.current_time
   (DateTime.now.to_time.to_f*1000).to_i
  end
  def initialize(*args)
    super(*args) do |f|
      self.class.current_time
    end
  end

  def unread_count
    last_read = key['last_read'].get()
    if(last_read)
      key.zcount(last_read,'+inf')
    else
      key.zcard
    end
  end
  def mark_as_read
    key['last_read'].set(self.class.current_time)
  end
  def inspect
    "#<TimestampedSet (#{model}): #{key.zrange(0,-1).inspect}>"
  end
  
end


class Ohm::Model::List < Ohm::Model::Collection
  alias :count :size
end
