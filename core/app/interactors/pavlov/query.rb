require 'active_support/concern'

module Pavlov
  module Query
    extend ActiveSupport::Concern
    include Pavlov::SmartInit

    module ClassMethods
      # make our interactors behave as Resque jobs
      def execute(*args)
        new(*args).execute
      end
    end
  end
end