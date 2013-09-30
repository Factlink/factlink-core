require 'spec_helper'

describe Interactors::Users::Delete do
  include PavlovSupport

  it 'persistant stores the delete flag' do
    password = 'qwerty'
    user = create(:full_user, password: password, password_confirmation: password)
    initial_username = user.username
    expect(user.deleted).to eq(false)

    as(user) do |pavlov|
      pavlov.interactor :'users/delete', user_id: user.id, current_user_password: password
    end

    reloaded_user = Pavlov.query(:'users_by_ids', user_ids:[user.id])[0]
    expect(reloaded_user.deleted).to eq(true)
    expect(reloaded_user.username).to_not include(initial_username)
  end
end
