class LoadDsl
  UserDsl = Struct.new(:state_user) do
    def state_graph_user
      state_user.graph_user
    end

    def load_site(url)
      Site.find(:url => url).first || Site.create(:url => url)
    end

    def load_fact(fact_string,url="http://example.org/", opts={})
      f = Fact.create(
        :site => load_site(url),
        :created_by => state_graph_user
      )
      f.require_saved_data
      f.data.displaystring = fact_string
      f.data.title = opts[:title] || url
      f.data.save

      f
    end

    def fact(fact_string,url="http://example.org/", opts={}, &block)
      f = load_fact(fact_string,url, opts)
      FactDsl.new(f).instance_eval(&block) if block_given?
    end

  end
end
