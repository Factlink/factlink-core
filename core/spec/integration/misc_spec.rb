require 'integration_helper'

describe "Compare screens", type: :request do

  it "should render the frontpage as expected" do
    u = create :user
    displaystrings = [
      "hoi",
      "hoi hoih ohiaetnoi htneoahtniahtn aeionhteoahtnaeo hni tnaeohtin haeotni haeotin heoatni haeotni hoeatni haeotni heoatnih aetnoih aetnoih aetnoi haetonih tnoaei htaenoih aetnoih aetnoihaetno hiaetnoaih aetnoi haeotni haeotnih aetnoih aeotni heoatni haeotnih tnoeahi aetnohi aetnohi aetnohi tnaohieo atnhaeiotn",
      "moi"
    ]
    3.times do |i|
      f1 = create :fact, created_by: u.graph_user
      f1.add_opinion :believes, u.graph_user
      f1.data.displaystring = displaystrings[i]
      f1.data.save
      f1.reposition_in_top
    end

    visit "/"
    assume_unchanged_screenshot "homepage"
  end

  [0,1,2,3,5,6].each do |i|
    it "should render the fake factpage with cid #{i} as expected" do
      visit "/x/3?cid=#{i}"
      assume_unchanged_screenshot "fake_fact_#{i}"
    end
  end

end