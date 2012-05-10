module Channels
  class AutoCompletedChannel < Mustache::Railstache
    def title
      h self[:topic].title
    end
  end
end
