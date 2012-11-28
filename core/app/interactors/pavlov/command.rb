require 'active_support/concern'

module Pavlov
  module Command
    extend ActiveSupport::Concern
    include Pavlov::Operation
    def authorized?
      true
    end
  end
end
