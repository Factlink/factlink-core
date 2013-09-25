require 'spec_helper'

describe Interactors::Users::Delete do
  include PavlovSupport

  it 'persistant stores the delete flag' do
    user = create :full_user
    expect(user.deleted).to eq(false)
    as(user) do |pavlov|
      described_class.new(user_id: user.id.to_s, pavlov_options: pavlov.pavlov_options).call
    end
    reloaded_user = Pavlov.query(:'users_by_ids', user_ids:[user.id])

    expect(reloaded_user.delete).to eq(true)
  end
end
