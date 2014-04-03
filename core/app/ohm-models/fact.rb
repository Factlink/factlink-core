class Fact < OurOhm
  class << self
    private :new, :create, :[]
  end
end
