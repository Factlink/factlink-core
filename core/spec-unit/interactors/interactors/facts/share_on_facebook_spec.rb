require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/share_on_facebook.rb'

describe Interactors::Facts::ShareOnFacebook do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '.authorized?' do
    it 'throws when cannot share facts' do
      ability = stub
      ability.stub(:can?)
             .with(:share, Fact)
             .and_return(false)

      pavlov_options = { current_user: mock,
                         ability: ability,
                         facebook_app_namespace: 'namespace' }

      interactor = described_class.new fact_id: '1',
        pavlov_options: pavlov_options

      expect { interactor.call }
        .to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '#call' do
    it 'calls the command to share on Facebook' do
      fact_id = '1'
      user    = mock
      ability = stub can?: true

      pavlov_options = { current_user: user,
                         ability: ability,
                         facebook_app_namespace: 'namespace' }

      Pavlov.should_receive(:old_command)
        .with(:'facebook/share_factlink', fact_id, pavlov_options)

      interactor = described_class.new fact_id: fact_id,
        pavlov_options: pavlov_options
      interactor.call
    end
  end

  describe 'validation' do
    it 'requires fact_id to be an integer string' do
      expect_validating(fact_id: 1)
        .to fail_validation('fact_id should be an integer string.')
    end

    it 'requires a current_user' do
      hash = { fact_id: '1', pavlov_options: { current_user: nil }}

      expect_validating(hash)
        .to fail_validation('current_user should not be nil.')
    end

    it 'requires a facebook_app_namespace' do
      hash = { fact_id: '1', pavlov_options: { facebook_app_namespace: nil,
        current_user: mock }}

      expect_validating(hash)
        .to fail_validation('facebook_app_namespace should be a nonempty string.')
    end
  end
end
