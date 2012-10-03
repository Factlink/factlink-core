module Interactor
  extend ActiveSupport::Concern

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