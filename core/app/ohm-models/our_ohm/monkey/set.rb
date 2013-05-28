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

  def make_empty
    key.del
  end

end
