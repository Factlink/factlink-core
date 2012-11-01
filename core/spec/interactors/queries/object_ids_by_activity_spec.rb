require File.expand_path('../../../../app/interactors/queries/object_ids_by_activity.rb', __FILE__)
require_relative '../interactor_spec_helper'

describe Queries::ObjectIdsByActivity do

  before do
    stub_classes 'Activity::Listener'
  end

  describe '.execute' do
    it 'retrieves the specified ids' do
      activity = mock()
      class_name = mock()
      list = mock()
      listener = mock()
      listener_hash = mock()
      result = mock()

      listener_hash.should_receive(:[]).with(class: class_name, list: list).
        and_return(listener)
      Activity::Listener.stub(all: listener_hash)

      listener.should_receive(:add_to).with(activity).and_return(result)

      Queries::ObjectIdsByActivity.any_instance.stub(authorized?: true)

      interactor = Queries::ObjectIdsByActivity.new activity, class_name, list

      expect(interactor.execute).to eq(result)
    end
  end
end
