require_relative '../../app/workers/add_timestamps_to_factrelation'

describe AddTimestampsToFactrelation do

  before do
    stub_const('Activity', Class.new)
    stub_const('FactRelation', Class.new)

    @fact_relation = stub( id: 1, type: :supporting )
  end

  describe '.perform' do

    it 'sets the timestamp to Time.now if no other timestamp is available' do
      stub_const('AddTimestampsToFactrelation::ActivityTimestamp', Class.new)
      AddTimestampsToFactrelation::ActivityTimestamp.stub( new: stub( timestamp: nil ) )
      AddTimestampsToFactrelation::FactsTimestamp.stub( new: stub( timestamp: nil ))
      FactRelation.should_receive(:[]).with(@fact_relation.id).and_return(@fact_relation)

      @fact_relation.stub(:created_at= => nil, :save => @fact_relation )
      Time.stub( now: stub( utc: stub( to_s: mock )))

      @fact_relation.should_receive(:created_at=).with( Time.now.utc.to_s )

      AddTimestampsToFactrelation.perform @fact_relation.id
    end

    it 'sets the timestamp to the activity timestamp if available' do
      stub_const('AddTimestampsToFactrelation::ActivityTimestamp', Class.new)

      timestamp = Time.now.utc.to_s
      AddTimestampsToFactrelation::ActivityTimestamp.stub( new: stub( timestamp: timestamp ) )
      FactRelation.should_receive(:[])
                  .with(@fact_relation.id).and_return(@fact_relation)

      @fact_relation.should_receive(:created_at=).with( timestamp )
      @fact_relation.should_receive(:save)

      AddTimestampsToFactrelation.perform @fact_relation.id
    end

    it 'sets the timestamp to the facts timestamp if there is no activity timestamp' do
      stub_const('AddTimestampsToFactrelation::ActivityTimestamp', Class.new)

      AddTimestampsToFactrelation::ActivityTimestamp.stub( new: stub( timestamp: nil ))
      timestamp = Time.now.utc.to_s
      AddTimestampsToFactrelation::FactsTimestamp.stub( new: stub( timestamp: timestamp ))
      FactRelation.should_receive(:[])
                  .with(@fact_relation.id).and_return(@fact_relation)

      @fact_relation.should_receive(:created_at=).with( timestamp )
      @fact_relation.should_receive(:save)

      AddTimestampsToFactrelation.perform @fact_relation.id
    end
  end

  describe AddTimestampsToFactrelation::ActivityTimestamp do

    it 'queries the correct added_evidence Activity' do
      fact = mock()

      activity = mock()
      activity.stub(subject_id: 17,
                    subject_class: fact,
                    action: :added_supporting_evidence,
                    created_at: Time.now.utc.to_s)

      Activity.should_receive(:find)
              .with(subject_id: @fact_relation.id,
                    subject_class: @fact_relation.class,
                    action: :added_supporting_evidence).and_return([activity])

      activity_timestamp = AddTimestampsToFactrelation::ActivityTimestamp.new @fact_relation
      expect(activity_timestamp.timestamp).to eq activity.created_at
    end

    describe '.activity_type' do

      describe 'returns :added_supporting_evidence when' do

        it 'fact_relation.type is :supporting' do
          fact_relation = stub( type: :supporting )

          activity_timestamp = AddTimestampsToFactrelation::ActivityTimestamp.new fact_relation
          expect(activity_timestamp.activity_type).to eq(:added_supporting_evidence)
        end

        it 'fact_relation.type is "supporting"' do
          fact_relation = stub( type: "supporting" )

          activity_timestamp = AddTimestampsToFactrelation::ActivityTimestamp.new fact_relation
          expect(activity_timestamp.activity_type).to eq(:added_supporting_evidence)
        end
      end

      describe 'returns :added_weakening_evidence when' do
        it 'fact_relation.type is :weakening' do
          fact_relation = stub( type: :weakening )

          activity_timestamp = AddTimestampsToFactrelation::ActivityTimestamp.new fact_relation
          expect(activity_timestamp.activity_type).to eq(:added_weakening_evidence)
        end

        it 'fact_relation.type is "weakening" ' do
          fact_relation = stub( type: "weakening" )

          activity_timestamp = AddTimestampsToFactrelation::ActivityTimestamp.new fact_relation
          expect(activity_timestamp.activity_type).to eq(:added_weakening_evidence)
        end
      end

    end
  end

  describe AddTimestampsToFactrelation::FactsTimestamp do

    describe '.max_timestamp' do
      it 'returns the timestamp of the top_fact when that one is more recent' do
        top_fact      = stub( created_at: "3013-02-29 11:36:16 UTC" )
        from_fact     = stub( created_at: "2013-01-28 10:35:13 UTC" )
        fact_relation = stub( fact: top_fact, from_fact: from_fact )

        ts = AddTimestampsToFactrelation::FactsTimestamp.new fact_relation
        expect(ts.max_timestamp).to eq top_fact.created_at
      end

      it 'returns the timestamp of the from_fact when that one is more recent' do
        top_fact      = stub( created_at: "2013-01-28 10:35:13 UTC" )
        from_fact     = stub( created_at: "3013-02-29 11:36:16 UTC" )
        fact_relation = stub( fact: top_fact, from_fact: from_fact )

        ts = AddTimestampsToFactrelation::FactsTimestamp.new fact_relation
        expect(ts.max_timestamp).to eq from_fact.created_at
      end
    end

    describe '.timestamp' do
      it "returns the .max_timestamp + one second" do
        ts = AddTimestampsToFactrelation::FactsTimestamp.new mock
        ts.stub max_timestamp: "2013-01-28 10:35:13 UTC"

        expect(ts.timestamp).to be_a String
        expect(ts.timestamp).to eq "2013-01-28 10:35:14 UTC"
      end
    end
  end
end

