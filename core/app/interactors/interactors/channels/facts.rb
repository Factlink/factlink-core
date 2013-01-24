module Interactors
  module Channels
    class Facts
      include Pavlov::Interactor

      arguments :id, :from, :count

      def execute
        # setting up defaults
        @from = (Time.now.utc.to_f*1000).to_i if @from.blank?
        @count = 7 if @count.blank?

        res = query :'channels/facts', @id, @from, @count

        # if there are facts without fact_data remove them.
        fixchan = false
        res.delete_if do |item|
          invalid = Fact.invalid(item[:item])
          fixchan |= invalid
          invalid
        end

        # if facts without fact_data were found start a resque job
        # to delete them.
        if fixchan
          # todo: this should be a command
          Resque.enqueue(CleanChannel, @id)
        end
        res
      end

      def authorized?
        @options[:current_user]
      end

      def validate
        validate_integer :from, @from, :allow_blank => true
        validate_integer :count, @count, :allow_blank => true
        validate_integer_string :id, @id
      end
    end
  end
end
