require 'pavlov'

# TODO revert warnings in pavlov
module Pavlov
  module Validations
    def warn *args
    end
  end
end

# TODO: merge private authorized pullrequest in pavlov

# TODO: validate should throw, also when calling valid?
