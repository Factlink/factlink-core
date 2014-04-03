# TODO refactor ohm so this works  lazy  and efficiently does the def the | and the -
class Ohm::Model::Set < Ohm::Model::Collection
  alias :count :size

  def ids
    key.smembers
  end

  def assign(set)
    apply(:sunionstore,set.key,set.key,key) #copy; dirty stupid code, sorry
  end

end
