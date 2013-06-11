class HashUtils
  def self.hash_with_index(index, list)
    list.each_with_object({}) do |u, hash|
      hash[u.send(index).to_s] = u
    end
  end
end
