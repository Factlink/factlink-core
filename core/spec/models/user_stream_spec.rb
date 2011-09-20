require 'spec_helper'

describe UserStream do
  subject {UserStream.new(u1)}

  let(:u1) { FactoryGirl.create(:user).graph_user }

  describe "initially" do
    it { subject.facts.to_a.should =~ []}
  end  

  describe "after adding one empty channel" do
    before do
      @ch1 = create(:channel, :created_by => u1)
      Channel.recalculate_all
    end
    it { subject.facts.to_a.should =~ []}
  end
  describe "after creating a fact" do
    before do
      @f1 = create(:fact, :created_by => u1)
    end
    it { subject.facts.to_a.should =~ [@f1]}
  end

  describe "after adding channel with one fact" do
    before do
      @ch1 = create(:channel, :created_by => u1)
      @f1 = create(:fact)
      @ch1.add_fact(@f1)
      Channel.recalculate_all
    end
    it { subject.facts.to_a.should =~ [@f1]}
  end
  describe "after adding two channels with one fact" do
    before do
      @ch1 = create(:channel, :created_by => u1)
      @f1 = create(:fact)
      @ch1.add_fact(@f1)
      @ch2 = create(:channel, :created_by => u1)
      @f2 = create(:fact)
      @ch2.add_fact(@f2)
      Channel.recalculate_all
    end
    it { subject.facts.to_a.should =~ [@f1,@f2]}
    describe "after creating a fact" do
      before do
        @f3 = create(:fact, :created_by => u1)
      end
      it { subject.facts.to_a.should =~ [@f1,@f2,@f3]}
    end
    
  end

end