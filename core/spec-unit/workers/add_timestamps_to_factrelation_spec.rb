require_relative '../../app/workers/add_timestamps_to_factrelation'

describe AddTimestampsToFactrelation do


  before do
    stub_const('Activity', Class.new)
    stub_const('FactRelation', Class.new)

    @fact_relation = stub( id: 1, type: :supporting )
  end

  describe '.perform' do

    it 'finds the FactRelation' do
      stub_const('AddTimestampsToFactrelation::ActivityTimestamp', Class.new)
      AddTimestampsToFactrelation::ActivityTimestamp.stub( new: stub( timestamp: nil ) )

      FactRelation.should_receive(:[]).with(@fact_relation.id).and_return(@fact_relation)

      @fact_relation.stub(:created_at= => nil, :save => @fact_relation )

      AddTimestampsToFactrelation.perform @fact_relation.id
    end

    it 'sets the timestamp' do
      stub_const('AddTimestampsToFactrelation::ActivityTimestamp', Class.new)

      timestamp = Time.now.utc.to_s
      AddTimestampsToFactrelation::ActivityTimestamp.stub( new: stub( timestamp: timestamp ) )
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
  end
end

