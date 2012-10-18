require 'active_support/concern'

module Pavlov
  module Interactor
    extend ActiveSupport::Concern
    include Pavlov::Operation

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
