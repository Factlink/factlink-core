class LoadDsl
  UserDsl = Struct.new(:state_user) do
    def fact(fact_string,url="http://example.org/", opts={}, &block)
      dead_fact = Backend::Facts.create displaystring: fact_string,
                                        site_url: url, site_title: opts.fetch(:title, url), created_at: Time.now

      FactDsl.new(dead_fact).instance_eval(&block) if block_given?
    end

  end
end
