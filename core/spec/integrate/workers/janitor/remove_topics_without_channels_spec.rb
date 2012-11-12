require 'spec_helper'

describe Janitor::RemoveTopicsWithoutChannels do
  describe ".perform" do
    before do
      @t1 = create :channel, title: 'Hoi'

      @t2 = create :channel, title: 'Doei'
      @t3 = create :channel, title: 'Doei'

      @t4 = create :channel, title: 'Doei2'
      @t5 = create :channel, title: 'Doei2'
    end

    it "should remove topics without channels" do
      Topic.all.map { |t| t.title }.should =~ ['Hoi', 'Doei', 'Doei2']

      [@t2,@t4,@t5].map { |t| t.delete}

      Janitor::RemoveTopicsWithoutChannels.perform()

      Topic.all.map { |t| t.title }.should =~ ['Hoi', 'Doei']
    end
  end
end