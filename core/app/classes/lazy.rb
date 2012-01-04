class Lazy
  def initialize &block
    @block = block
  end
  
  def humpapa
    @humpapa ||= @block.call
  end
  
  def method_missing(method, *args, &block)
    @humpapa.send method, *args, &block
  end
end