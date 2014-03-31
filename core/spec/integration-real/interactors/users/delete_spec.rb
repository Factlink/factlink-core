require 'spec_helper'

describe Interactors::Users::Delete do
  include PavlovSupport

  it 'persistant stores the delete flag' do
    password = 'qwerty'
    user = create(:user, password: password, password_confirmation: password)
    initial_username = user.username
    expect(user.deleted).to eq(false)

    as(user) do |pavlov|
      pavlov.interactor :'users/delete', username: user.username, current_user_password: password
    end

    reloaded_user = Backend::Users.by_ids(user_ids:[user.id])[0]
    expect(reloaded_user.deleted).to eq(true)
    expect(reloaded_user.username).to_not include(initial_username)
  end
end
