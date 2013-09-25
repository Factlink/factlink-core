require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/users/handpicked'

describe Queries::Users::Handpicked do
  include PavlovSupport

  before do
    stub_classes 'HandpickedTourUsers'
  end

  describe '#call' do

    it 'should return the dead handpicked_users' do
      dead_users = [
        double(:dead_user, id: double),
        double(:dead_user, id: double),
      ]

      user_ids = dead_users.map(&:id)

      HandpickedTourUsers.stub(:new)
        .and_return double(ids: user_ids)

      query = described_class.new

      Pavlov.stub(:query)
            .with(:'users_by_ids', user_ids: user_ids, top_topics_limit: 2)
            .and_return(dead_users)

      expect(query.call).to match_array dead_users
    end
  end

end
