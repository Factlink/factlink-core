module Acceptance
  class DiscussionPage
    # including factview helper, for friendly fact path:
    include ::FactHelper

    class SupportingEvidence
      def initialize test, fact
        @test = test
        @fact = fact
      end

      def nr
        0
      end

      def add_new text
        @test.wait_until_scope_exists '.auto-complete-fact-relations' do
          input = @test.page.find(:css, 'input')
          input.set(text)
          input.trigger('focus')
          @test.wait_for_ajax
        end

        @test.page.find('.fact-relation-post').click
      end
    end



    def initialize(test, id)
      @test = test
      @fact_id = id
    end

    def goto
      @test.visit path
    end

    def supporting_evidence
      SupportingEvidence.new @test, fact
    end

    def path
      @test.frurl_fact_path slug, @fact_id
    end

    def slug
      friendly_fact_slug(fact)
    end

    def fact
      @fact ||= Fact[@fact_id]
    end
  end
end

