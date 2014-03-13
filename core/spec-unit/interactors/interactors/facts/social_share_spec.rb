require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/social_share.rb'

describe Interactors::Facts::SocialShare do
  include PavlovSupport

  before do
    stub_classes 'Resque', 'Commands::Twitter::ShareFactlink', 'Commands::Facebook::ShareFactlink', 'Fact'
  end

  describe 'validation' do
    it 'without connected Twitter doesn\'t validate' do
      social_account = double
      current_user = double
      ability = double
      pavlov_options = {ability: ability, current_user: current_user}
      hash = {id: '1', provider_names: ['twitter'], pavlov_options: pavlov_options }

      current_user.stub(:social_account).with(:twitter).and_return(social_account)
      ability.stub(:can?).with(:share_to, social_account).and_return(false)

      expect_validating( hash )
        .to fail_validation('base no twitter account linked')
    end

    it 'without connected Facebook doesn\'t validate' do
      social_account = double
      current_user = double
      ability = double
      pavlov_options = {ability: ability, current_user: current_user}
      hash = {id: '1', provider_names: ['facebook'], pavlov_options: pavlov_options }

      current_user.stub(:social_account).with(:facebook).and_return(social_account)
      ability.stub(:can?).with(:share_to, social_account).and_return(false)

      expect_validating( hash )
        .to fail_validation('base no facebook account linked')
    end
  end

  describe '#call' do

    it 'posts to twitter if specified' do
      fact_id = '1'
      ability = double(can?: true)
      current_user = double(id: '123asdf', social_account: double)

      pavlov_options = {current_user: current_user, ability: ability}
      command = described_class.new id: fact_id, message: nil,
                                    provider_names: ['twitter'], pavlov_options: pavlov_options

      Pavlov.should_receive(:command)
            .with(:'twitter/share_factlink', id: fact_id, message: nil,
              pavlov_options: pavlov_options)

      command.call
    end

    it 'posts to facebook if specified' do
      fact_id = '1'
      message = 'message'
      ability = double(can?: true)
      current_user = double(id: '123asdf', social_account: double)

      pavlov_options = {current_user: current_user, ability: ability}
      command = described_class.new id: fact_id, message: message,
                                    provider_names: ['facebook'], pavlov_options: pavlov_options

      Pavlov.should_receive(:command)
            .with(:'facebook/share_factlink', id: fact_id, message: message,
              pavlov_options: pavlov_options)

      command.call
    end
  end
end
