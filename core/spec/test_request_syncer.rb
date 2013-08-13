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
      execute_script('window.test_counter ='+TestRequestSyncer.test_counter.to_s + '; sessionStorage.setItem("test_counter",window.test_counter);');
    end
  end

  class ::Capybara::Session
    prepend VisitTracker
  end

  class ::ApplicationController
    around_filter do |controller, action_block|
      puts "#{controller.request.referer} -> #{controller.request.original_url}"
      test_counter = params[:test_counter]
      if !test_counter && controller.request.referer then
        referer_query = URI.parse(controller.request.referer).query
        if referer_query then
          referer_params = CGI.parse(referer_query)
          test_counter = referer_params['test_counter'][0]
        end
      end
      puts "#{test_counter} == #{TestRequestSyncer.test_counter}"
      if test_counter == TestRequestSyncer.test_counter.to_s then
        action_block.call
      else
        puts "fail!"
        # require 'pry'
        # binding.pry
      end
    end
  end
end
