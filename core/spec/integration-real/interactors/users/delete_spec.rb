require 'spec_helper'

describe Interactors::Users::Delete do
  include PavlovSupport

  it 'persistant stores the delete flag' do
    user = create :full_user
    initial_username = user.username
    expect(user.deleted).to eq(false)
    as(user) do |pavlov|
      described_class.new(user_id: user.id.to_s, pavlov_options: pavlov.pavlov_options).call
    end
    reloaded_user = Pavlov.query(:'users_by_ids', user_ids:[user.id])[0]
    expect(reloaded_user.deleted).to eq(true)
    expect(reloaded_user.username).to_not include(initial_username)
  end
end
