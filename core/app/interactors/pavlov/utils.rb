module Pavlov
  module Utils
    def hash_with_index(index, list)
      list.each_with_object({}) {|u, hash| hash[u.send(index)] = u}
    end
  end
end
