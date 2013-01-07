class Believable
  class Commentje < Believable
    def initialize id
      key = Ohm::Key.new("Comment:#{id}:believable")
      super key
    end
  end
end
