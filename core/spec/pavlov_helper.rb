require 'pavlov'
require 'pavlov/alpha_compatibility'
require_relative '../app/interactors/util/can_can.rb'
require_relative '../app/interactors/util/validations.rb'
require_relative '../app/interactors/util/pavlov_context_serialization.rb'
require_relative 'support/unit/pavlov_support.rb'

# We want to be able to always use these simple value classes
# They should not be stubbed/mocked, but just used
require_relative '../app/classes/opinion_type.rb'
