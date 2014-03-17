module Commands
  module Comments
    class Create
      include Pavlov::Command

      arguments :fact_id, :content, :user_id

      def execute
        Backend::Comments.create(fact_id: fact_id, content: content, user_id: user_id)
      end
    end
  end
end
