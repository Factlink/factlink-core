require_relative '../pavlov'

module Queries
  class UserByUsername
    include Pavlov::Query
    arguments :username

    def validate
      validate_regex :username, @username, /\A[A-Za-z0-9_]*\Z/i,
                    "should consist of alphanumerical characters"
    end

    def execute
      User.first(:conditions => { username: /^#{@username.downcase}$/i })
    end

    def authorized?
      true
    end
  end
end
