class MapReduce
  class Example < MapReduce
    def initialize &block
      @block = block
    end

    def all_set
      @all || []
    end

    def all_set=(list)
      @all = list
    end

    def map iterator
      iterator.each do |i|
        i.each_pair do |k,v|
          yield k, v*v
        end
      end
    end

    def reduce bucket, partials
        partials.inject(:+)
    end

    def write_output k,v
      @block.call k,v
    end
  end
end
