require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/delete'

describe Interactors::Users::Delete do
  include PavlovSupport


  describe '#authorized?' do
    before do
      stub_classes 'User'
      #described_class.any_instance.stub(validate: true)
    end

    it 'throws when non-existant user passed' do
      user_id = double(:user_id)
      User.stub(:find).with(user_id).and_return(nil)
      ability = double(:ability)
      ability.stub(:can?).with(:delete, nil).and_return(false)

      #TODO: initial workaround, but this self-stubbing needs cleanup
      described_class.any_instance.stub(:validate_hexadecimal_string).and_return(true)

      interactor = described_class.new(user_id: user_id, pavlov_options: { ability: ability } )
      expect do
        interactor.call
      end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end

    it 'throws when unauthorized' do
      other_user = double(:user)
      other_user_id = double(:user_id)

      ability = double(:ability)

      User.stub(:find).with(other_user_id).and_return(other_user)

      ability.stub(:can?).with(:delete, other_user).and_return(false)

      #TODO: initial workaround, but this self-stubbing needs cleanup
      described_class.any_instance.stub(:validate_hexadecimal_string).and_return(true)

      interactor = described_class.new(user_id: other_user_id, pavlov_options: {ability: ability})
      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end

    it 'is authorized when cancan says so' do
      user = double(:user)
      user_id = double(:user_id)

      ability = double(:ability)

      User.stub(:find).with(user_id).and_return(user)

      ability.stub(:can?).with(:delete, user).and_return(true)

      interactor = described_class.new(user_id: user_id, pavlov_options: {ability: ability})
      expect(interactor.authorized?)
        .to eq(true)
    end
  end

  describe '#validate' do
    it 'with fixnum user_id doesn\'t validate' do
      expect_validating(user_id: 12)
      .to fail_validation('user_id should be an hexadecimal string.')
    end

    it 'without user_id doesn\'t validate' do
      expect_validating({})
        .to fail_validation('user_id should be an hexadecimal string.')
    end
  end

  describe '#call' do
    #before do
    #  described_class.any_instance.stub(authorized?: true, validate: true)
    #end
    #
    #it 'it calls the query to get a list of followed users' do
    #  user_name = double
    #  skip = double
    #  take = double
    #  current_user = double(graph_user_id: double)
    #  pavlov_options = { current_user: current_user }
    #  interactor = described_class.new(user_name: user_name, skip: skip,
    #                                   take: take, pavlov_options: pavlov_options)
    #  users = double(length: double)
    #  graph_user_ids = double
    #  count = double
    #  user = double(graph_user_id: double)
    #  followed_by_me = true
    #
    #  Pavlov.should_receive(:query)
    #  .with(:'user_by_username',
    #        username: user_name, pavlov_options: pavlov_options)
    #  .and_return(user)
    #  Pavlov.should_receive(:query)
    #  .with(:'users/follower_graph_user_ids',
    #        graph_user_id: user.graph_user_id.to_s,
    #        pavlov_options: pavlov_options)
    #  .and_return(graph_user_ids)
    #  Pavlov.should_receive(:query)
    #  .with(:'users_by_graph_user_ids',
    #        graph_user_ids: graph_user_ids, pavlov_options: pavlov_options)
    #  .and_return(users)
    #
    #  graph_user_ids.should_receive(:include?)
    #  .with(current_user.graph_user_id)
    #  .and_return(followed_by_me)
    #
    #  users.should_receive(:drop)
    #  .with(skip)
    #  .and_return(users)
    #  users.should_receive(:take)
    #  .with(take)
    #  .and_return(users)
    #
    #  returned_users, returned_count, returned_followed_by_me = interactor.call
    #
    #  expect(returned_users).to eq users
    #  expect(returned_count).to eq users.length
    #  expect(returned_followed_by_me).to eq followed_by_me
    #end
  end
end
