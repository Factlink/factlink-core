class LoadDsl
  UserDsl = Struct.new(:state_user) do
    def fact(fact_string,url="http://example.org/", opts={}, &block)
      dead_fact = Backend::Facts.create displaystring: fact_string,
        url: url, site_title: opts[:title] || url

      FactDsl.new(Fact[dead_fact.id]).instance_eval(&block) if block_given?
    end

  end
end
