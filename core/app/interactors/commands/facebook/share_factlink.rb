module Commands
  module Facebook
    class ShareFactlink
      include Pavlov::Command

      arguments :fact_id, :message

      private

      def execute
        client.put_wall_post message || '',
          name: fact.trimmed_quote(100),
          link: url,
          caption: caption,
          description: 'Read more'
      end

      def token
        pavlov_options[:current_user].social_account('facebook').token
      end

      def caption
        em_dash = "\u2014"
        "#{fact.host} #{em_dash} #{fact.title}"
      end

      def url
        @url ||= ::FactUrl.new(fact).sharing_url
      end

      def fact
        @fact ||= query(:'facts/get_dead', id: fact_id)
      end

      def client
        ::Koala::Facebook::API.new(token)
      end

    end
  end
end
