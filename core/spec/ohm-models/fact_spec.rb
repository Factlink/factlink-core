require 'spec_helper'
require_relative 'believable_shared'

describe Fact do
  it_behaves_like 'a believable object'

  def self.other_one(this)
    this == :supporting ? :weakening : :supporting
  end

  def other_one(this)
    self.class.other_one(this)
  end

  subject(:fact) { create :fact }

  let(:factlink) { create :fact }

  let(:graph_user) { create(:graph_user) }

  before do
    # TODO: remove this once activities are not created in the models any more, but in interactors
    stub_const 'Activity::Subject', Class.new
    Activity::Subject.stub(:activity)
  end

  describe ".delete" do
    it "works" do
      old_id = fact.id
      data_id = fact.data.id

      fact.delete

      expect(Fact[old_id]).to be_nil
      expect(FactData.find(data_id)).to be_nil
    end

    it "removes the fact from the creators facts list" do
      gu = fact.created_by
      expect(gu.sorted_created_facts.count).to eq 1

      fact.delete
      expect(gu.sorted_created_facts.count).to eq 0
    end
  end

  it "has the GraphUser set when a opinion is added" do
    parent = create :fact
    parent.add_opinion(:believes, graph_user)
    expect(parent.opiniated(:believes).to_a).to match_array [graph_user]
  end

  it "is in the created_facts set of the creator" do
    gu = fact.created_by
    expect(gu.created_facts.to_a).to match_array [fact]
  end

  context "initially" do
    it "should have no evidence for a type, or the :both type" do
      expect(fact.evidence(:supporting).count).to eq 0
      expect(fact.evidence(:weakening).count).to eq 0
      expect(fact.evidence(:both).count).to eq 0
    end
  end

  [:supporting, :weakening].each do |relation|
    describe ".add_evidence" do

      context "with one #{relation} fact" do
        before do
          @fr = fact.add_evidence(relation,factlink,graph_user)
        end

        describe "should have one evidence" do
          it "for the relation #{relation}" do
            expect(fact.evidence(relation).count).to eq 1
          end
          it "for :both" do
            expect(fact.evidence(:both).count).to eq 1
          end
        end

        describe ".delete the fact, which has a #{relation} fact" do
          it "removes everything which depends on it" do
            @fact_id = fact.id
            @data_id = fact.data.id
            @relation_id = @fr.id
            fact.delete

            expect(Fact[@fact_id]).to be_nil
            expect(FactData.find(@data_id)).to be_nil

            expect(FactRelation[@relation_id]).to be_nil
          end
        end
        describe ".delete the #{relation} fact" do
          it "removes everything which depends on it" do
            @factlink_id = factlink.id
            @data_id = factlink.data.id
            @relation_id = @fr.id
            factlink.delete

            expect(Fact[@factlink_id]).to be_nil
            expect(FactData.find(@data_id)).to be_nil
            expect(FactRelation[@relation_id]).to be_nil
          end
        end
      end

      context "with two #{relation} fact" do
        it "should have two #{relation} facts and two facts for :both" do

          factlink2 = create :fact

          fact.add_evidence(relation,factlink,graph_user)
          fact.add_evidence(relation,factlink2,graph_user)

          expect(fact.evidence(relation).count).to eq 2
          expect(fact.evidence(:both).count).to eq 2
        end
      end

      context "with one #{relation} fact and one #{other_one(relation)} fact" do
        it "should have one #{relation}, one #{other_one(relation)} fact and two for :both" do
          factlink2 = create :fact

          fact.add_evidence(relation,factlink,graph_user)
          fact.add_evidence(other_one(relation),factlink2,graph_user)

          expect(fact.evidence(relation).count).to eq 1
          expect(fact.evidence(other_one(relation)).count).to eq 1
          expect(fact.evidence(:both).count).to eq 2
        end
      end
    end
  end


  describe "Mongoid properties: " do
    context "after setting a displaystring to 'hiephoi'" do
      it "the facts to_s is 'hiephoi'" do
        fact.data.displaystring = "hiephoi"
        expect(fact.to_s).to eq "hiephoi"
      end
    end

    it "should not give a give a document not found for Factdata" do
      f = Fact.create created_by: graph_user
      f.data.displaystring = "This is a fact"
      f.data.save
      f.save

      f2 = Fact[f.id]

      expect(f2.data.displaystring).to eq "This is a fact"
    end

    describe ".created_at" do
      it 'returns the created_at of the FactData in Ohm format (UTC string)' do
        expect(fact.created_at).to be_a String
        expect(fact.created_at).to eq(fact.data.created_at.utc.to_s)
      end
    end
  end

  describe '.has_site?' do
    it "returns false when no site is specified" do
      fact = create :fact, site: nil
      expect(fact.has_site?).to be_false
    end
    it "returns false when the site has no url" do
      fact = create :fact, site: (create :site, url: nil)
      expect(fact.has_site?).to be_false
    end
    it "returns false when the site has a blank url" do
      fact = create :fact, site: (create :site, url: ' ')
      expect(fact.has_site?).to be_false
    end
  end

  it 'creating a fact adds to graph_users sorted_created_facts' do
    fact = Fact.create created_by: graph_user

    expect(graph_user.sorted_created_facts.to_a).to match_array [fact]
  end

  describe '#channel_ids' do
    include PavlovSupport
    include RedisSupport

    it "returns the channels it is contained in, using 1 redis command" do
      user = create :user
      fact = create :fact

      ch1 = create :channel, created_by: user.graph_user
      ch2 = create :channel, created_by: user.graph_user
      ch3 = create :channel, created_by: user.graph_user

      as(user) do |p|
        [ch1, ch2, ch3].each do |channel|
          p.command :'channels/add_fact',
                    fact: fact, channel: channel
        end
      end
      ids = :undefined

      nr = number_of_commands_on Ohm.redis do
        ids = fact.channel_ids
      end

      expect(ids).to eq [ch1.id, ch2.id, ch3.id]
      expect(nr).to eq 1
    end
  end
end
