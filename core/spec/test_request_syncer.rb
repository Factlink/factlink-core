module TestRequestSyncer
  @test_counter = 1
  class << self
    attr_accessor :test_counter
    def increment_counter
      @test_counter += 1
    end
  end

  module VisitTracker
    def visit(url, *args, &block)
      if url
        url = url.sub(/\?|$/,"?test_counter=#{TestRequestSyncer.test_counter}&")
      end
      super(url, *args,&block)
    end
  end

  class ::Capybara::Session
    prepend VisitTracker
  end

  module TestCounterInjector
    def inject_special_test_code
      "<script>
        window.test_counter = #{TestRequestSyncer.test_counter};
      </script>".html_safe + super
    end
    def redirect_to(*args, &block)
      res = super(*args, &block)
      self.location = self.location.sub(/\?|$/,"?test_counter=#{TestRequestSyncer.test_counter}&")
      res
    end
  end

  class ::ApplicationController
    prepend TestCounterInjector
    around_filter do |controller, action_block|
      # puts "#{controller.request.referer} -> #{controller.request.original_url}"
      test_counter = params[:test_counter] || cookies[:test_counter]
      if !test_counter && controller.request.referer then
        referer_query = URI.parse(controller.request.referer).query
        if referer_query then
          referer_params = CGI.parse(referer_query)
          test_counter = referer_params['test_counter'][0]
        end
      end
      # puts "#{test_counter} == #{TestRequestSyncer.test_counter}"
      if test_counter == TestRequestSyncer.test_counter.to_s then
        action_block.call
      else
        puts "\nINVALID TEST COUNTER (#{test_counter} not #{TestRequestSyncer.test_counter})"
        puts "#{controller.request.original_url} from #{controller.request.referer}"
        puts "Aborted request\n"
      end
    end
  end
end
