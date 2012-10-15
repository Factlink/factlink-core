require 'active_support/concern'

module Query
  extend ActiveSupport::Concern

  module ClassMethods
    # make our interactors behave as Resque jobs
    def execute(*args)
      new(*args).execute
    end
  end
end
