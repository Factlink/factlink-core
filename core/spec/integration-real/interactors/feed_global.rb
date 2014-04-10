require 'spec_helper'

describe Interactors::Feed::Global do
  include PavlovSupport

  describe '#call' do
    it 'filters out invalid activities' do
      user = create :user
      fact_data = create :fact_data
      as(user) do |pavlov|

        comment1 = pavlov.interactor :'comments/create', fact_id: fact_data.fact_id, content: 'hallo1'
        sleep 0.001
        comment2 = pavlov.interactor :'comments/create', fact_id: fact_data.fact_id, content: 'hallo2'
        sleep 0.001
        comment3 = pavlov.interactor :'comments/create', fact_id: fact_data.fact_id, content: 'hallo3'

        feed_before_delete = pavlov.interactor :'feed/global', count: '2'
        p feed_before_delete.map{|c|c[:comment].formatted_content}
        expect(feed_before_delete.size).to eq 2
        expect(feed_before_delete[1][:comment].formatted_content).to eq 'hallo2'

        pavlov.interactor :'comments/delete', comment_id: comment2.id.to_s

        feed_after_delete = pavlov.interactor :'feed/global', count: '2'
        p feed_after_delete.map{|c|c[:comment].formatted_content}
        expect(feed_after_delete.size).to eq 2
        expect(feed_after_delete[1][:comment].formatted_content).to eq 'hallo1'
      end
    end
  end
end
