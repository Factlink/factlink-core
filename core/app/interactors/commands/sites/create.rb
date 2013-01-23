module Commands
  module Sites
    class Create
      include Pavlov::Command

      arguments :url

      def execute
        ::Site.create(url: @url)
      end

      def validate
        validate_nonempty_string :url, @url
      end
    end
  end
end
