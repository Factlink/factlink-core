module Interactors
  module Facts
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      arguments :displaystring, :url, :title

      def authorized?
        can? :create, Fact
      end

      private

      def execute
        fact = Backend::Facts.create displaystring: displaystring,
          url: url, title: title

        if user
          command(:'facts/add_to_recently_viewed',
                    fact_id: fact.id.to_i, user_id: user.id.to_s)
        end

        fact
      end

      def user
        pavlov_options[:current_user]
      end

      def validate
        validate_nonempty_string :displaystring, displaystring
        validate_string :title, title
        validate_string :url, url
      end
    end
  end
end
