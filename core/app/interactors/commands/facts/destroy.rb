module Commands
  module Facts
    class Destroy
      include Pavlov::Command

      arguments :fact_id

      def execute
        fact.delete
      end

      def fact
        Fact[fact_id]
      end
    end
  end
end
