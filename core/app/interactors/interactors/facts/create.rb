module Interactors
  module Facts
    class Create
      include Pavlov::Interactor

      arguments :displaystring, :url, :title

      def execute
        unless @url.blank?
          site = query :'sites/for_url', @url

          if site.nil?
            site = command :'sites/create', @url
          end
        else
          site = nil
        end

        fact = command :'facts/create', @displaystring, @title, @options[:current_user], site
        command :"facts/add_to_recently_viewed", fact.id.to_i, @options[:current_user].id.to_s
        fact
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
