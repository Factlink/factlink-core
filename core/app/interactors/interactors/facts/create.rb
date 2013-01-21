module Interactors
  module Facts
    class Create
      include Pavlov::Interactor

      arguments :displaystring, :url, :title

      def execute
        site = query :'sites/for_url', @url

        if site.nil?
          site = command :'sites/create', @url
        end

        command :'facts/create', @displaystring, @title, @options[:current_user], site
      end

      def authorized?
        @options[:current_user]
      end

      def validate
        validate_string :title, @title
        validate_string :url, @url
        validate_nonempty_string :displaystring, @displaystring
      end
    end
  end
end
