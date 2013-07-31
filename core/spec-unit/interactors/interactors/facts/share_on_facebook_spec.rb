require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/share_on_facebook.rb'

describe Interactors::Facts::ShareOnFacebook do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '.authorized?' do
    it 'throws when cannot share facts' do
      ability = double
      ability.stub(:can?)
             .with(:share, Fact)
             .and_return(false)

      pavlov_options = { current_user: mock,
                         ability: ability,
                         facebook_app_namespace: 'namespace' }

      expect do
        described_class.new '1', pavlov_options
      end.to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '#call' do
    it 'calls the command to share on Facebook' do
      fact_id = '1'
      user    = double
      ability = stub can?: true

      pavlov_options = { current_user: user,
                         ability: ability,
                         facebook_app_namespace: 'namespace' }

      Pavlov.should_receive(:old_command)
        .with(:'facebook/share_factlink', fact_id, pavlov_options)

      interactor = described_class.new fact_id, pavlov_options
      interactor.call
    end
  end

  describe '.validate' do
    it 'calls the correct validation methods' do
      fact_id   = '1'
      namespace = 'namespace'
      user      = double
      ability   = stub can?: true

      described_class
        .any_instance
        .should_receive(:validate_integer_string)
        .with(:fact_id, fact_id)

      described_class
        .any_instance
        .should_receive(:validate_not_nil)
        .with(:current_user, user)

      described_class.any_instance
        .should_receive(:validate_nonempty_string)
        .with(:facebook_app_namespace, namespace)

      pavlov_options = { current_user: user,
                         ability: ability,
                         facebook_app_namespace: namespace
                       }

      interactor = described_class.new fact_id, pavlov_options
    end
  end

end
