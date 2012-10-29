require_relative '../pavlov'

module Queries
  class UserByUsername
    include Pavlov::Query
    arguments :username
    def execute
      User.first(:conditions => { :username => @username })
    end
    def authorized?
      true
    end
  end
end
