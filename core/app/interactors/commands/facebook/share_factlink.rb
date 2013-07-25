module Commands
  module Facebook
    class ShareFactlink
      include Pavlov::Command

      arguments :fact_id, :pavlov_options

      private

      def execute
        client.put_connections("me", "#{namespace}:share", factlink: fact.url.fact_url)
      end

      def token
        pavlov_options[:current_user].identities['facebook']['credentials']['token']
      end

      def fact
        @fact ||= old_query :'facts/get_dead', @fact_id
      end

      def namespace
        pavlov_options[:facebook_app_namespace]
      end

      def client
        ::Koala::Facebook::API.new(token)
      end

      def validate
        # HACK! Fix this through pavlov serialization (ask @markijbema or @janpaul123)
        if pavlov_options.has_key? 'serialize_id'
          self.pavlov_options = Util::PavlovContextSerialization.deserialize_pavlov_context(pavlov_options)
        end

        validate_integer_string  :fact_id, fact_id
        validate_nonempty_string :facebook_app_namespace,
                                  pavlov_options[:facebook_app_namespace]
      end

    end
  end
end
