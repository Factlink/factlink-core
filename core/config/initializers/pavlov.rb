# Monkey patch to introduce pavlov_options before upgrading

module Pavlov
  module Operation
    def pavlov_options
      @options
    end
    def pavlov_options=(options)
      @options = options
    end
  end
end
