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
      test_counter = params[:test_counter]
      if !test_counter || test_counter == TestRequestSyncer.test_counter.to_s then
        action_block.call
      end
    end
  end
end
