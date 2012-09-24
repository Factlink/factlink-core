require 'spec_helper'

describe FactsController, type: :controller do
  render_views

  let(:user) { FactoryGirl.create(:user) }
  let(:fact) { FactoryGirl.create(:fact) }

  describe :new do
    it "should work" do
      authenticate_user!(user)
      Benchmark.bmbm do |bm|
        bm.report do
          100.times do
            post 'new', :url => "http://example.org/",  :displaystring => "Facity Fact", :title => "Title"
          end
        end
      end
    end
  end

end
