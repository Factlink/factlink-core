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
      </script>".html_safe +
          (<<-'SNIPPET'
      <script>
        if(/^(::1|127\.0\.0\.1|localhost)$/.test(window.location.hostname)) {
          window.addEventListener('unload', function(){ //phantomjs doesn't support beforeunload
            document.cookie = 'test_counter='+window.test_counter+';path=/';
          });
          function testCounterBackbonePatcher() {
            document.removeEventListener('DOMContentLoaded', testCounterBackbonePatcher);
            if(!window.Backbone) return;
            var old_ajax = Backbone.ajax;
            Backbone.ajax = function(options) {
              if (arguments.length !== 1) {
                throw new Error("Factlink's overridden ajax method only supports the 1-argument (an options object) style ajax");
              }
              options.url = options.url.replace(/\?|$/, '?test_counter=' + window.test_counter + '&');
              return old_ajax(options);
            };
          }
          document.addEventListener('DOMContentLoaded', testCounterBackbonePatcher);
        }
      </script>
          SNIPPET
          ).html_safe + super
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
      test_counter = params[:test_counter]
      if !test_counter && controller.request.referer
        referer_query = URI.parse(controller.request.referer).query
        if referer_query
          referer_params = CGI.parse(referer_query)
          test_counter = referer_params['test_counter'][0]
        end
      end
      test_counter = cookies[:test_counter] if !test_counter
      if test_counter == TestRequestSyncer.test_counter.to_s
        action_block.call
      # if you need to debug race conditions surrounding test-end,
      # then uncommenting the following lines may be handy:
      # else
      #   puts "\nINVALID TEST COUNTER (#{test_counter} not #{TestRequestSyncer.test_counter})"
      #   puts "#{controller.request.original_url} from #{controller.request.referer}"
      #   puts "Aborted request\n"
      end
    end
  end
end
