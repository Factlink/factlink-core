require 'spec_helper'
require_relative '../../app/workers/add_timestamps_to_factrelation'

describe AddTimestampsToFactrelation do

  describe '.perform' do

    before do
      @fact_relation = create :fact_relation
      @fact_relation.stub( id: 1 )
    end

    it 'finds the FactRelation' do
      stub_const('FactRelation', Class.new)
      FactRelation.should_receive(:[]).with(@fact_relation.id).and_return(@fact_relation)

      AddTimestampsToFactrelation.perform @fact_relation.id
    end

    it 'queries the correct added_evidence Activity' do
      stub_const('Activity', Class.new)
      stub_const('FactRelation', Class.new)

      fact = mock()

      activity = mock()
      activity.stub(subject_id: 17, subject_class: fact, action: :added_supporting_evidence, created_at: DateTime.now)

      @fact_relation.stub(type: :supporting)

      @fact_relation.should_receive(:created_at=).with(activity.created_at)
      @fact_relation.should_receive(:updated_at=).with(activity.created_at)
      @fact_relation.should_receive(:save).and_return(false)

      FactRelation.should_receive(:[]).with(@fact_relation.id).and_return(@fact_relation)
      Activity.should_receive(:find).with(subject_id: @fact_relation.id, subject_class: @fact_relation.class, action: :added_supporting_evidence).and_return([activity])

      AddTimestampsToFactrelation.perform @fact_relation.id
    end
  end
end
