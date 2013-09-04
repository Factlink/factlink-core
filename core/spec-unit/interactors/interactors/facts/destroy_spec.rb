require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/destroy.rb'

describe Interactors::Facts::Destroy do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe 'validation' do
    it 'without fact_id doesn\'t validate' do
      expect_validating({fact_id: '' })
        .to fail_validation('fact_id should be an integer string.')
    end
  end

  it '.authorized raises when not able to create facts' do
    ability = double
    ability.stub(:can?)
             .with(:manage, Fact)
             .and_return(false)

    interactor = described_class.new fact_id: '14',
                   pavlov_options: { ability: ability }

    expect { interactor.call }
      .to raise_error Pavlov::AccessDenied, "Unauthorized"
  end

  describe '#call' do
    it 'deletes the fact when it has no evidence' do
      fact = double id: '32', evidence_count: 0

      pavlov_options = { current_user: double, ability: double(can?: true) }

      Pavlov.stub(:query).with(:'facts/get_dead', fact_id: fact.id, pavlov_options: pavlov_options)
                    .and_return(fact)

      interactor = described_class.new fact_id: fact.id,
                     pavlov_options: pavlov_options

      Pavlov.should_receive(:command).with(:'facts/destroy', fact_id: fact.id,
        pavlov_options: pavlov_options)

      interactor.call
    end

    it 'does not delete the fact when it has evidence' do
      fact = double id: '33', evidence_count: 1

      pavlov_options = { current_user: double, ability: double(can?: true) }

      Pavlov.stub(:query).with(:'facts/get_dead', fact_id: fact.id, pavlov_options: pavlov_options)
                    .and_return(fact)

      interactor = described_class.new fact_id: fact.id,
                     pavlov_options: pavlov_options

      Pavlov.should_not_receive(:command).with(:'facts/destroy', fact_id: fact.id,
        pavlov_options: pavlov_options)

      interactor.call
    end
  end

end
