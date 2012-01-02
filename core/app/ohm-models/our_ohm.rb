require 'ohm/contrib'

require_relative 'our_ohm/generic_reference'
require_relative 'our_ohm/value_reference'

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

  def below(limit,opts={})
    if opts[:count]
      redis_opts = { limit: [0,opts[:count]] }
    else
      redis_opts = {}
    end

    redis_opts[:withscores] = opts[:withscores]

    res = key.zrevrangebyscore("(#{limit}",'-inf',redis_opts)

    if opts[:withscores]
      res = self.class.hash_array_for_withscores(res).map {|x| { item: model[x[:item]], score: x[:score]}}
    else
      res = res.map(&model)
    end
    opts[:reversed]? res : res.reverse
  end

  def self.hash_array_for_withscores(arr)
    res = []
    (arr.length / 2).times do |i|
      res << {
        item:arr[i*2],
        score:arr[i*2+1].to_f
      }
    end
    res
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

  alias :until :below

  def inspect
    "#<TimestampedSet (#{model}): #{key.zrange(0,-1).inspect}>"
  end

end


class Ohm::Model::List < Ohm::Model::Collection
  alias :count :size
end
