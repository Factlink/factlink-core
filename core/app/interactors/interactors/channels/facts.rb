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

        facts = remove_invalid facts

        facts
      end

      def remove_invalid facts
        # if there are facts without fact_data remove them.
        @there_are_invalid_facts = false
        facts.delete_if {|item| invalid item }

        # if facts without fact_data were found start a resque job
        # to delete them.
        # todo: this should be a command
        Resque.enqueue(CleanChannel, @id) if @there_are_invalid_facts

        facts
      end

      def invalid fact_with_score
        invalid = Fact.invalid(fact_with_score[:item])
        @there_are_invalid_facts |= invalid
        invalid
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
