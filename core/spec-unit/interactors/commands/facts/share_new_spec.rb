require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/facts/share_new.rb'

describe Commands::Facts::ShareNew do
  include PavlovSupport

  describe '#validate' do
    before do
      stub_const 'Pavlov::ValidationError', RuntimeError
    end

    it 'sanitizes sharing options' do
      fact_id = '1'
      sharing_options = {}
      user = mock(identities: {})

      described_class.any_instance.should_receive(:sanitize_boolean_hash)
                                  .with(:sharing_options)

      command = described_class.new fact_id, sharing_options, current_user: user
    end

    it 'calls the correct validation methods' do
      fact_id = '1'
      sharing_options = {twitter: true, facebook: true}
      user = mock(identities: {'twitter' => mock, 'facebook' => mock})

      described_class.any_instance.should_receive(:validate_integer_string)
                                  .with(:fact_id, fact_id)

      command = described_class.new fact_id, sharing_options, current_user: user
    end

    it 'throws an error if no twitter account is linked but wants to post to twitter' do
      fact_id = '1'
      sharing_options = {twitter: true, facebook: false}
      user = mock(identities: {})

      expect { described_class.new fact_id, sharing_options, current_user: user }
        .to raise_error(Pavlov::ValidationError, 'no twitter account linked')
    end

    it 'throws an error if no facebook account is linked but wants to post to facebook' do
      fact_id = '1'
      sharing_options = {twitter: false, facebook: true}
      user = mock(identities: {})

      expect { described_class.new fact_id, sharing_options, current_user: user }
        .to raise_error(Pavlov::ValidationError, 'no facebook account linked')
    end
  end

  describe '.execute' do
    it 'posts to twitter if specified' do
      fact_id = '1'
      sharing_options = {twitter: true, facebook: false}
      user = mock(identities: {'twitter' => mock, 'facebook' => mock})

      pavlov_options = {current_user: user}
      command = described_class.new fact_id, sharing_options, pavlov_options

      Pavlov.should_receive(:command)
            .with(:'twitter/share_factlink', fact_id, pavlov_options)

      command.call
    end

    it 'posts to facebook if specified' do
      fact_id = '1'
      sharing_options = {twitter: false, facebook: true}
      user = mock(identities: {'twitter' => mock, 'facebook' => mock})

      pavlov_options = {current_user: user}
      command = described_class.new fact_id, sharing_options, pavlov_options

      Pavlov.should_receive(:command)
            .with(:'facebook/share_factlink', fact_id, pavlov_options)

      command.call
    end
  end
end
