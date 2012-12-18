require 'pavlov_helper'
require_relative '../../../app/interactors/queries/object_ids_by_activity.rb'

describe Queries::ObjectIdsByActivity do
  include PavlovSupport

  before do
    stub_classes 'Activity::Listener'
  end

  describe '.call' do
    it 'retrieves the specified ids' do
      activity = mock()
      class_name = mock()
      list = mock()
      listener = mock()
      result = mock()

      interactor = Queries::ObjectIdsByActivity.new activity, class_name, list
      interactor.should_receive(:listener).and_return(listener)
      listener.should_receive(:add_to).with(activity).and_return(result)

      expect(interactor.call).to eq(result)
    end
  end

  describe '.listener' do
    it 'gets the listener' do
      class_name = mock()
      list = mock()
      listener = mock()
      listener_hash = mock()

      interactor = Queries::ObjectIdsByActivity.new mock(), class_name, list

      listener_hash.should_receive(:[]).with(class: class_name, list: list).
        and_return(listener)
      Activity::Listener.stub(all: listener_hash)

      expect(interactor.listener).to eq(listener)
    end
  end
end
