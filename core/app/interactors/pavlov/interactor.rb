require 'active_support/concern'

module Pavlov
  module Interactor
    extend ActiveSupport::Concern
    include Pavlov::SmartInit

    # this method is also available as constantize in Rails,
    # but we want to be able to write classes and/or tests without Rails
    def get_class_by_string classname
      classname.split('::').inject(Kernel) {|x,y|x.const_get(y)}
    end

    def command command_name, *args
      klass = get_class_by_string("Commands::"+command_name.to_s.camelize)
      klass.new(*args).execute
    end

    module ClassMethods
      # make our interactors behave as Resque jobs
      def perform(*args)
        new(*args).execute
      end

      def queue
        @queue || :interactor_operations
      end
    end
  end
end
