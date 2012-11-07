module Pavlov
  module CanCan
    def can? *args
      @options[:ability].can?(*args)
    end
  end
end
