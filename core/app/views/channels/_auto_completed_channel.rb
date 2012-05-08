module Channels
  class AutoCompletedChannel < Mustache::Railstache
    def title
      self[:topic].title
    end
  end
end
