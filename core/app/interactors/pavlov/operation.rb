require 'active_support/concern'

module Pavlov
  module Operation
    extend ActiveSupport::Concern
    include Pavlov::Helpers
    def pavlov_options
      @options
    end

    def raise_unauthorized
      raise CanCan::AccessDenied
    end

    def check_authority
      raise_unauthorized unless respond_to? :authorized? and authorized?
    end

    def initialize *params
      keys = (respond_to? :arguments) ? arguments : []
      names = params.first(keys.length)
      if params.length == keys.length + 1
        @options = params.last
      elsif params.length == keys.length
        @options = {}
      else
        raise "wrong number of arguments."
      end

      (keys.zip names).each do |pair|
        name = "@" + pair[0].to_s
        value = pair[1]
        instance_variable_set(name, value)
      end

      validate if respond_to? :validate
      check_authority
      finish_initialize if respond_to? :finish_initialize
    end

    module ClassMethods
      # arguments :foo, :bar
      #
      # results in
      #
      # def initialize(foo, bar)
      #   @foo = foo
      #   @bar = bar
      # end
      def arguments *keys
        define_method :arguments do
          keys
        end
      end
    end
  end
end
