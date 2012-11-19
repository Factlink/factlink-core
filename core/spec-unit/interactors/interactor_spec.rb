require 'active_support'
require_relative '../../app/interactors/pavlov/interactor.rb'

describe Pavlov::Interactor do
  it 'should have a class which has a queue method which returns a default queue' do
    i = Class.new
    i.send(:include, Pavlov::Interactor)
    i.should respond_to(:queue)
    i.queue.should == :interactor_operations
  end
end
