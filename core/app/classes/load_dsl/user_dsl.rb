class LoadDsl
  UserDsl = Struct.new(:state_user) do
    def state_graph_user
      state_user.graph_user
    end

    def load_site(url)
      Site.find(:url => url).first || Site.create(:url => url)
    end

    def load_fact(fact_string,url="http://example.org/", opts={})
      dead_fact = Backend::Facts.create displaystring: fact_string,
        url: url, site_title: opts[:title] || url

      Fact[dead_fact.id]
    end

    def fact(fact_string,url="http://example.org/", opts={}, &block)
      f = load_fact(fact_string,url, opts)
      FactDsl.new(f).instance_eval(&block) if block_given?
    end

  end
end
