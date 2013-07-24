class NestedHashHashStore
  def initialize
    @hash = {}
  end

  def value?
    not @value.nil?
  end

  def get
    @value or raise "no value"
  end

  def []=(key, value)
    self[key].set value
  end

  def [](key)
    @hash[key] ||= NestedHashHashStore.new
  end

  protected

  def set value
    @value = value
  end
end
