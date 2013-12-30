require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facts/social_share.rb'

describe Commands::Facts::SocialShare do
  include PavlovSupport

  describe 'validation' do
    it 'without connected Twitter doesn\'t validate' do
      social_account = double
      current_user = double
      ability = double
      pavlov_options = {ability: ability, current_user: current_user}
      hash = {fact_id: '1', provider_names: { twitter: true }, pavlov_options: pavlov_options }

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
      hash = {fact_id: '1', provider_names: { facebook: true }, pavlov_options: pavlov_options }

      current_user.stub(:social_account).with(:facebook).and_return(social_account)
      ability.stub(:can?).with(:share_to, social_account).and_return(false)

      expect_validating( hash )
        .to fail_validation('base no facebook account linked')
    end
  end

  describe '#call' do
    before do
      stub_classes 'Resque', 'Commands::Twitter::ShareFactlink', 'Commands::Facebook::ShareFactlink'
    end

    it 'posts to twitter if specified' do
      fact_id = '1'
      provider_names = {twitter: true, facebook: false}
      ability = double(can?: true)
      current_user = double(id: '123asdf', social_account: double)

      pavlov_options = {current_user: current_user, ability: ability}
      command = described_class.new fact_id: fact_id,
                                    provider_names: provider_names, pavlov_options: pavlov_options

      Resque.should_receive(:enqueue)
            .with(Commands::Twitter::ShareFactlink, fact_id: fact_id, pavlov_options: { 'serialize_id' => current_user.id })

      command.call
    end

    it 'posts to facebook if specified' do
      fact_id = '1'
      provider_names = {twitter: false, facebook: true}
      ability = double(can?: true)
      current_user = double(id: '123asdf', social_account: double)

      pavlov_options = {current_user: current_user, ability: ability}
      command = described_class.new fact_id: fact_id,
                                    provider_names: provider_names, pavlov_options: pavlov_options

      Resque.should_receive(:enqueue)
            .with(Commands::Facebook::ShareFactlink, fact_id: fact_id, pavlov_options: { 'serialize_id' => current_user.id })

      command.call
    end
  end
end
