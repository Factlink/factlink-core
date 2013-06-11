module HashUtils
  def hash_with_index(index, list)
    list.each_with_object({}) do |u, hash|
      hash[u.send(index).to_s] = u
    end
  end
  module_function :hash_with_index
end
