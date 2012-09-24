require 'spec_helper'

describe FactsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:fact) { create(:fact) }

  describe :new do
    it "should work" do
      authenticate_user!(user)
      Benchmark.bmbm do |bm|
        bm.report do
          # this number is chosen so that it takes about 10 seconds on marks mac (total)
          # initially it was 200 -> ~10 total
          200.times do
            post 'new', :url => "http://example.org/",  :displaystring => "Facity Fact", :title => "Title"
          end
        end
      end
    end
  end

end
