module Pavlov
    # this method is also available as constantize in Rails,
    # but we want to be able to write classes and/or tests without Rails
    def self.get_class_by_string classname
      classname.split('::').inject(Kernel) {|x,y|x.const_get(y)}
    end

    def self.command command_name, *args
      klass = get_class_by_string("Commands::"+command_name.to_s.camelize)
      klass.new(*args).execute
    end

    def self.interactor command_name, *args
      klass = get_class_by_string(command_name.to_s.camelize + "Interactor")
      klass.new(*args).execute
    end

    def self.query command_name, *args
      klass = get_class_by_string("Queries::"+command_name.to_s.camelize)
      klass.new(*args).execute
    end


end

require_relative 'pavlov/helpers.rb'
require_relative 'pavlov/validations.rb'
require_relative 'pavlov/operation.rb'
require_relative 'pavlov/command.rb'
require_relative 'pavlov/query.rb'
require_relative 'pavlov/interactor.rb'
