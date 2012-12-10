module Pavlov
  # this method is also available as constantize in Rails,
  # but we want to be able to write classes and/or tests without Rails
  def self.get_class_by_string classname
    classname.constantize
  end

  def self.string_to_classname string
    string.to_s.camelize
  end

  def self.command command_name, *args
    class_name = "Commands::"+string_to_classname(command_name)
    klass = get_class_by_string(class_name)
    klass.new(*args).execute
  end

  def self.interactor command_name, *args
    class_name = "Interactors::"+string_to_classname(command_name)
    klass = get_class_by_string class_name
    klass.new(*args).execute
  end

  def self.query command_name, *args
    class_name = "Queries::"+string_to_classname(command_name)
    klass = get_class_by_string class_name
    klass.new(*args).execute
  end
end

require_relative 'pavlov/helpers.rb'
require_relative 'pavlov/utils.rb'
require_relative 'pavlov/access_denied.rb'
require_relative 'pavlov/validation_error.rb'
require_relative 'pavlov/validations.rb'
require_relative 'pavlov/operation.rb'
require_relative 'pavlov/command.rb'
require_relative 'pavlov/query.rb'
require_relative 'pavlov/interactor.rb'
require_relative 'pavlov/mixpanel.rb'
require_relative 'pavlov/can_can.rb'
require_relative 'pavlov/search_helper.rb'
