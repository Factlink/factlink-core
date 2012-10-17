require 'active_support/concern'

module Pavlov
  module Command
    extend ActiveSupport::Concern
    include SmartInit
  end
end
