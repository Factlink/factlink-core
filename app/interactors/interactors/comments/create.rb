module Interactors
  module Comments
    class Create
      include Pavlov::Interactor

      attribute :content, String
      attribute :fact_id, String
      attribute :markup_format, String, default: 'plaintext'
      attribute :pavlov_options, Hash

      def execute
        comment = Backend::Comments.create \
          fact_id: fact_id,
          content: content,
          markup_format: markup_format,
          user_id: pavlov_options[:current_user].id.to_s,
          created_at: pavlov_options[:time]

        unless pavlov_options[:import]
          Backend::Comments.set_opinion \
            comment_id: comment.id.to_s, opinion: 'believes',
            user_id: pavlov_options[:current_user].id
        end

        create_activity comment

        Backend::Comments.by_ids(ids: comment.id,
          current_user_id: pavlov_options[:current_user].id).first
      end

      def create_activity comment
        Backend::Activities.create \
                    user_id: pavlov_options[:current_user].id,
                    action: :created_comment,
                    subject: comment,
                    time: pavlov_options[:time],
                    send_mails: pavlov_options[:send_mails]
      end

      def authorized?
        pavlov_options[:current_user]
      end

      def validate
        validate_regex   :content, content, /\S/,
          "should not be empty."
        validate_integer_string :fact_id, fact_id
        validate_in_set :markup_format, markup_format, ['plaintext', 'anecdote']

        if markup_format == 'anecdote'
          anecdote = JSON.parse(content)
          unless  %w{introduction insight resources actions effect}.all?{|key| anecdote.has_key?(key)}
            fail 'Incorrect anecdote format'
          end
        end
      end
    end
  end
end
