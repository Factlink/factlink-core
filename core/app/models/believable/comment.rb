class Believable
  class Comment < Believable
    def initialize id
      key = Nest.new("Comment:#{id}:believable")
      super key
    end
  end
end
