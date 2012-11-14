require 'active_support/concern'

module Pavlov
  module Query
    extend ActiveSupport::Concern
    include Pavlov::Operation

    module ClassMethods
      # make our interactors behave as Resque jobs
      def execute(*args)
        new(*args).execute
      end
    end
    def authorized?
      true
    end
  end
end
