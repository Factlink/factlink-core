module Commands
  module Facebook
    class ShareFactlink
      include Pavlov::Command

      arguments :fact_id

      private

      def execute
        em_dash = "\u2014"

        client.put_wall_post '',
          name: quote,
          link: url,
          caption: "#{fact.host} #{em_dash} #{fact.title}",
          description: 'Read more',
          picture: 'http://cdn.factlink.com/1/fact-wheel-questionmark.png'
      end

      def token
        pavlov_options[:current_user].identities['facebook']['credentials']['token']
      end

      def quote
        query :'facts/quote', fact: fact, max_length: 100
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
