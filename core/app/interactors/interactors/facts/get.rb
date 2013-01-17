module Interactors
  module Facts
    class Get
      include Pavlov::Interactor

      arguments :id

      def execute
        query :'facts/get', @id
      end

      def authorized?
        @options[:current_user]
      end

      def validate
        validate_integer_string :id, @id
      end
    end
  end
end
