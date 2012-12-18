require 'active_support/concern'

module Pavlov
  module Query
    extend ActiveSupport::Concern
    include Pavlov::Operation

    def authorized?
      true
    end
  end
end
