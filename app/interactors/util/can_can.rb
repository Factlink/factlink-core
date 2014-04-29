module Util
  module CanCan
    def can? *args
      pavlov_options[:ability].can?(*args)
    end
  end
end
