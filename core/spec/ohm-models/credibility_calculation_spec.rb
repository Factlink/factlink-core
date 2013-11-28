require 'spec_helper'


describe "credibility calculation of facts*users" do
  include RedisSupport

  def add_fact_to_channel fact, channel
    Interactors::Channels::AddFact.new(fact: fact, channel: channel,
      pavlov_options: { no_current_user: true }).call
  end

  let(:u1) { create(:graph_user) }
  let(:u2) { create(:graph_user) }
  let(:u3) { create(:graph_user) }
  let(:u4) { create(:graph_user) }

  let(:f1) { create(:fact) }
  let(:f2) { create(:fact) }
  let(:f3) { create(:fact) }
  let(:f4) { create(:fact) }
  let(:f5) { create(:fact) }
  let(:f6) { create(:fact) }
  let(:f7) { create(:fact) }

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.stub(:activity)
  end

  def recalculate_credibility
    MapReduce::FactCredibility.new.process_all
  end

  it "should average authority on topics" do
    ch1 = create(:channel, created_by: u1)
    ch2 = create(:channel, created_by: u1)
    Authority.from(ch1.topic, for: u1) << 10.0
    Authority.from(ch2.topic, for: u1) << 20.0
    add_fact_to_channel f1, ch1
    add_fact_to_channel f1, ch2

    recalculate_credibility
    expect(Authority.on(f1, for: u1).to_f).to eq(15.0)
  end

  it "should not be influenced by authorities of other users" do
    ch1 = create(:channel, created_by: u1)
    ch2 = create(:channel, created_by: u1)
    Authority.from(ch1.topic, for: u1) << 10.0
    Authority.from(ch2.topic, for: u1) << 20.0
    add_fact_to_channel f1, ch1
    add_fact_to_channel f1, ch2

    # some data that shouldn't influence the outcome
    Authority.from(ch1.topic, for: u2) << 100.0
    Authority.from(ch2.topic, for: u2) << 100.0
    Authority.from(f1, for: u2) << 100.0
    Authority.from(f1) << 100.0
    add_fact_to_channel f2, ch2
    add_fact_to_channel f3, ch2
    ch3 = create(:channel, created_by: u2)
    add_fact_to_channel f3, ch3

    recalculate_credibility
    expect(Authority.on(f1, for: u1).to_f).to eq(15.0)
  end

  it "should work with different channels with the same topic (same names)" do
    ch1 = create(:channel, created_by: u1, title: 'a')
    ch2 = create(:channel, created_by: u2, title: 'a')
    ch3 = create(:channel, created_by: u2, title: 'b')
    Authority.from(ch1.topic, for: u1) << 10.0 # will be counted twice
    Authority.from(ch3.topic, for: u1) << 40.0
    add_fact_to_channel f1, ch1
    add_fact_to_channel f1, ch2
    add_fact_to_channel f1, ch3

    recalculate_credibility
    expect(Authority.on(f1, for: u1).to_f).to eq(20.0)
  end
end
