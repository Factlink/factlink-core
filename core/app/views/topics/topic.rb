module Topics
  class Topic < Mustache::Railstache
    def title
      self[:topic].title
    end
  end
end
