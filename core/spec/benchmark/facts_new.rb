require 'spec_helper'

def add_channel usser, name
  channel = Channel.new title: name
  channel.created_by =  user.graph_user
  channel.save
end

describe FactsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:fact) { create(:fact) }


  describe :new do
    it "should work" do
      authenticate_user!(user)

      20.times do |i|
        add_channel user, "Channel #{i}"
      end

      Benchmark.bmbm do |bm|
        bm.report do
          # this number is chosen so that it takes about 10 seconds on marks mac (total)
          # initially it was with 20 channels 42 runs -> ~10 seconds total
          #
          # after not prefetching channels:
          # 20 channels, 225 runs -> ~10 seconds total
          225.times do |i|
            post 'new', :url => "http://example.org/#{i}",  :displaystring => "Facity Fact (#{i})", :title => "Title nr. #{i}"
          end
        end
      end
    end
  end

end
