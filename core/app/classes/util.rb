class Utils
  def self.hash_with_index(index, list)
    list.each_with_object({}) {|u, hash| hash[u.send(index)] = u}
  end
end
