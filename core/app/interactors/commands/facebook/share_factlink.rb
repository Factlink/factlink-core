module Commands
  module Facebook
    class ShareFactlink
      include Pavlov::Command

      arguments :fact_id

      private

      def execute
        client.put_wall_post '',
          name: fact.quotes.trimmed_quote(100),
          link: url,
          caption: caption,
          description: 'Read more',
          picture: 'http://cdn.factlink.com/1/facebook-factwheel-logo.png'
      end

      def token
        pavlov_options[:current_user].identities['facebook']['credentials']['token']
      end

      def caption
        return '' unless fact.has_site?

        em_dash = "\u2014"
        "#{fact.host} #{em_dash} #{fact.title}"
      end

      def url
        @url ||= ::FactUrl.new(fact).sharing_url
      end

      def fact
        @fact ||= query(:'facts/get_dead', id: fact_id)
      end

      def namespace # kept around for when we switch back to OpenGraph sharing
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
