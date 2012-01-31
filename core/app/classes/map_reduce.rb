class MapReduce
  def all_iterator

  end

  def one_iterator

  end

  def map iterator
    result_hash = {}
    internal_map iterator do |bucket, value|
      result_hash[bucket] ||= []
      result_hash[bucket] << value
    end
    result_hash
  end

  def reduce iterator, partial
    result = 0
    internal_reduce iterator, partial do |iterator, partial|
      result = partial
    end
    result
  end
end
