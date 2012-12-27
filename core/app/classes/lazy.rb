class Lazy
  def initialize &block
    @block = block
  end

  def original_object_container
    @original_object_container ||= @block.call
  end

  def to_s
    original_object_container.to_s
  end

  def to_json *args
    original_object_container.to_json(*args)
  end

  def method_missing(method, *args, &block)
    original_object_container.send(method, *args, &block)
  end
end
