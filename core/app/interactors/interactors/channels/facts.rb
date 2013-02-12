module Interactors
  module Channels
    class Facts
      include Pavlov::Interactor

      arguments :id, :from, :count

      def setup_defaults
        @count = 7 if @count.blank?
      end

      def execute
        setup_defaults

        facts = query :'channels/facts', @id, @from, @count

        remove_invalid facts
      end

      def remove_invalid facts
        # if there are facts without fact_data remove them.
        valid_facts = facts.reject {|fact_with_score| invalid fact_with_score }

        # if facts without fact_data were found start a resque job
        # to delete them.
        if valid_facts.length != facts.length
          #TODO: this should be a command
          Resque.enqueue(CleanChannel, @id)
        end

        valid_facts
      end

      def invalid fact_with_score
        Fact.invalid(fact_with_score[:item])
      end

      def authorized?
        @options[:current_user]
      end

      def validate
        validate_integer :from, @from, allow_blank: true
        validate_integer :count, @count, allow_blank: true
        validate_integer_string :id, @id
      end
    end
  end
end
