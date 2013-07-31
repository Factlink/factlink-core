require 'pavlov_helper'
require_relative '../../../app/interactors/queries/object_ids_by_activity.rb'

describe Queries::ObjectIdsByActivity do
  include PavlovSupport

  before do
    stub_classes 'Activity::Listener'
  end

  describe '#call' do
    it 'retrieves the specified ids' do
      activity = double
      class_name = double
      list = double
      listener = double
      ids = [mock(:id)]

      interactor = Queries::ObjectIdsByActivity.new activity, class_name, list
      interactor.should_receive(:listeners)
                .and_return([listener])
      listener.should_receive(:add_to)
              .with(activity)
              .and_return(ids)

      expect(interactor.call).to eq(ids)
    end
  end

  describe '.listeners' do
    it 'gets the listeners' do
      class_name = double
      list = double
      listener = double
      listener_hash = double

      interactor = Queries::ObjectIdsByActivity.new mock(), class_name, list

      listener_hash.should_receive(:[]).with(class: class_name, list: list).
        and_return([listener])
      Activity::Listener.stub(all: listener_hash)

      expect(interactor.listeners).to eq([listener])
    end
  end
end
