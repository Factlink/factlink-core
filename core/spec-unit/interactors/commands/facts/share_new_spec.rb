require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facts/share_new.rb'

describe Commands::Facts::ShareNew do
  include PavlovSupport

  describe 'validation' do
    it 'without fact_id doesn\'t validate' do
      expect_validating({fact_id: '' })
        .to fail_validation('fact_id should be an integer string.')
    end

    it 'without connected Twitter doesn\'t validate' do
      hash = {fact_id: '1', sharing_options: { twitter: true }, pavlov_options: {ability: double(can?: false)} }

      expect_validating( hash )
        .to fail_validation('no twitter account linked')
    end

    it 'without connected Facebook doesn\'t validate' do
      hash = {fact_id: '1', sharing_options: { facebook: true }, pavlov_options: {ability: double(can?: false)} }

      expect_validating( hash )
        .to fail_validation('no facebook account linked')
    end
  end

  describe '#call' do
    before do
      stub_classes 'Resque', 'Commands::Twitter::ShareFactlink', 'Commands::Facebook::ShareFactlink'
    end

    it 'posts to twitter if specified' do
      fact_id = '1'
      sharing_options = {twitter: true, facebook: false}
      ability = double(can?: true)
      current_user = double(id: '123asdf')

      pavlov_options = {current_user: current_user, ability: ability}
      command = described_class.new fact_id: fact_id,
        sharing_options: sharing_options, pavlov_options: pavlov_options

      Resque.should_receive(:enqueue)
            .with(Commands::Twitter::ShareFactlink, fact_id: fact_id, pavlov_options: { 'serialize_id' => current_user.id })

      command.call
    end

    it 'posts to facebook if specified' do
      fact_id = '1'
      sharing_options = {twitter: false, facebook: true}
      ability = double(can?: true)
      current_user = double(id: '123asdf')

      pavlov_options = {current_user: current_user, ability: ability}
      command = described_class.new fact_id: fact_id,
        sharing_options: sharing_options, pavlov_options: pavlov_options

      Resque.should_receive(:enqueue)
            .with(Commands::Facebook::ShareFactlink, fact_id: fact_id, pavlov_options: { 'serialize_id' => current_user.id })

      command.call
    end
  end
end
