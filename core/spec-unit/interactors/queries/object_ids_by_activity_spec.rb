require 'pavlov_helper'
require_relative '../../../app/interactors/queries/object_ids_by_activity.rb'

describe Queries::ObjectIdsByActivity do
  include PavlovSupport

  before do
    stub_classes 'Activity::Listener'
  end

  describe '#call' do
    it 'retrieves the specified ids' do
      activity = mock
      class_name = mock
      list = mock
      listener = mock
      ids = [mock(:id)]
      interactor = described_class.new activity: activity,
        class_name: class_name, list: list

      interactor.should_receive(:listeners)
                .and_return([listener])
      listener.should_receive(:add_to)
              .with(activity)
              .and_return(ids)

      expect(interactor.call).to eq(ids)
    end
  end

  describe '#listeners' do
    it 'gets the listeners' do
      class_name = mock
      list = mock
      listener = mock
      listener_hash = mock
      interactor = Queries::ObjectIdsByActivity.new activity: mock(),
        class_name: class_name, list: list

      listener_hash.should_receive(:[])
        .with(class: class_name, list: list)
        .and_return([listener])
      Activity::Listener.stub(all: listener_hash)

      expect(interactor.listeners).to eq([listener])
    end
  end
end
