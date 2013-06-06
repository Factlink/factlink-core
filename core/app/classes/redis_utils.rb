module RedisUtils
  def hash_array_for_withscores flat_array
    array_of_pairs = flat_array.each_slice(2)

    array_of_pairs.map do |pair|
      {item: pair[0], score: pair[1].to_f}
    end
  end
end
