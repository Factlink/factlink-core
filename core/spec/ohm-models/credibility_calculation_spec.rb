require 'spec_helper'


describe "credibility calculation of facts*users" do
  include RedisSupport

  def add_fact_to_channel fact, channel
    Interactors::Channels::AddFact.new(fact, channel, no_current_user: true).execute
  end

  let(:u1) {FactoryGirl.create(:graph_user)}
  let(:u2) {FactoryGirl.create(:graph_user)}
  let(:u3) {FactoryGirl.create(:graph_user)}
  let(:u4) {FactoryGirl.create(:graph_user)}

  let(:f1) {FactoryGirl.create(:fact)}
  let(:f2) {FactoryGirl.create(:fact)}
  let(:f3) {FactoryGirl.create(:fact)}
  let(:f4) {FactoryGirl.create(:fact)}
  let(:f5) {FactoryGirl.create(:fact)}
  let(:f6) {FactoryGirl.create(:fact)}
  let(:f7) {FactoryGirl.create(:fact)}

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.should_receive(:activity).any_number_of_times
  end

  def recalculate_credibility
    MapReduce::FactCredibility.new.process_all
    MapReduce::FactRelationCredibility.new.process_all
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

  it "should not be influenced by the nesting of channels" do
    ch1 = create(:channel, created_by: u1)
    ch2 = create(:channel, created_by: u1)
    Authority.from(ch1.topic, for: u1) << 10.0
    Authority.from(ch2.topic, for: u1) << 20.0
    add_fact_to_channel f1, ch1
    add_fact_to_channel f1, ch2

    # some data that shouldn't influence the outcome
    ch1.add_channel(ch2)

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

  it "should work with fact relations and the topics of the to_fact" do
    ch1 = create(:channel, created_by: u1)
    ch2 = create(:channel, created_by: u1)
    Authority.from(ch1.topic, for: u1) << 10.0
    Authority.from(ch2.topic, for: u1) << 20.0

    fr = f1.add_evidence(:supporting, f2, u1)
    add_fact_to_channel f1, ch1
    add_fact_to_channel f1, ch2

    # some data that shouldn't influence the outcome
    ch3 = create(:channel, created_by: u1)
    add_fact_to_channel f2, ch3
    Authority.from(ch3.topic, for: u1) << 100.0

    recalculate_credibility
    expect(Authority.on(fr, for: u1).to_f).to eq(15.0)
  end
end
