require 'pavlov'
require 'strict_struct'
require 'pavlov/alpha_compatibility'
require_relative '../app/interactors/util/can_can.rb'
require_relative 'support/unit/pavlov_support.rb'

# We want to be able to always use these simple value classes
# They should not be stubbed/mocked, but just used
require_relative '../app/classes/opinion_type.rb'
require_relative '../app/entities/dead_fact.rb'
require_relative '../app/entities/dead_sub_comment.rb'
I18n.enforce_available_locales = true
