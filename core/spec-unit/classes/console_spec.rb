require 'pavlov_helper'
require_relative '../../app/classes/console.rb'

describe Console do
  include PavlovSupport

  before do
    stub_classes 'Ability', 'User'
  end

  it 'forwards interactor methods to Pavlov, with correct user and ability' do
    user = mock :user, username: 'mark'
    ability = mock
    options = { current_user: user, ability: ability }
    param1, param2 = mock, mock

    User.stub(:find)
        .with(user.username)
        .and_return(user)
    Ability.stub(:new)
           .with(user)
           .and_return(ability)

    Pavlov.should_receive(:interactor)
          .with(:foo, param1, param2, options)

    console = Console.new(user.username)
    console.interactor :foo, param1, param2
  end
end
