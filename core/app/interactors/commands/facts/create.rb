module Commands
  module Facts
    class Create
      include Pavlov::Command

      arguments :displaystring, :title, :creator, :site

      def execute
        fact_params = {created_by: creator.graph_user}
        fact_params[:site] = site if site
        fact = Fact.new fact_params
        fact.data = create_fact_data
        fact.save
        fact.data.fact_id = fact.id
        fact.data.save
        fact
      end

      def create_fact_data
        fact_data = FactData.new
        fact_data.displaystring = @displaystring
        fact_data.title = @title
        fact_data.save
        fact_data
      end

      def validate
        validate_string :title, @title
        validate_not_nil :creator, @creator
        validate_nonempty_string :displaystring, @displaystring
      end
    end
  end
end
