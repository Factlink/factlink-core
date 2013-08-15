require 'pavlov_helper'
require_relative '../../app/classes/pavlov_console.rb'

describe PavlovConsole do
  include PavlovSupport

  before do
    stub_classes 'User', 'Util::PavlovContextSerialization'
  end

  it 'forwards interactor methods to Pavlov, with correct options' do
    user = double :user, username: 'mark'
    options = double
    param1, param2 = double, double

    User.stub(:find)
        .with(user.username)
        .and_return(user)
    Util::PavlovContextSerialization.stub(:pavlov_context_by_user)
           .with(user)
           .and_return(options)

    Pavlov.should_receive(:interactor)
          .with(:foo, param1: param1, param2: param2, pavlov_options: options)

    console = PavlovConsole.new(user.username)
    console.interactor :foo, param1: param1, param2: param2
  end
end
