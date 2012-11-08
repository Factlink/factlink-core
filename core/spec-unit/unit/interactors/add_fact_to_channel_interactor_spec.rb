require 'pavlov_helper'
require File.expand_path('../../../../app/interactors/add_fact_to_channel_interactor.rb', __FILE__)

describe AddFactToChannelInteractor do
  include PavlovSupport

  let(:relaxed_ability) do
    ability = mock()
    ability.stub can?: true
    ability
  end

  def fake_class
    Class.new
  end

  before do
    stub_const 'Fact', fake_class
    stub_const 'Channel', fake_class
  end

  it 'initializes' do
    interactor = AddFactToChannelInteractor.new '1', '1'
    interactor.should_not be_nil
  end

  it 'raises when initialized with a fact id that is a string' do
    expect { interactor = AddFactToChannelInteractor.new 'not an id', '1'}.
      to raise_error(RuntimeError, 'Fact_id should be an integer.')
  end

  it 'raises when initialized with a channel id that is a string' do
    expect { interactor = AddFactToChannelInteractor.new '1','not an id'}.
      to raise_error(RuntimeError, 'Channel_id should be an integer.')
  end

  it 'raises when initialized with a channel that is nil' do
    expect { interactor = AddFactToChannelInteractor.new '1', nil}.
      to raise_error(RuntimeError, 'Channel_id should be an integer.')
  end

  it 'raises when executed without any permission' do
    Channel.stub :[] => nil

    ability = mock()
    ability.should_receive(:can?).and_return(false)

    interactor = AddFactToChannelInteractor.new '1', '1', ability: ability
    expect { interactor.execute }.to raise_error(Pavlov::AccessDenied)
  end

  describe '.execute' do
    context 'when properly initialized' do
      it 'executes correctly' do
        fact_id = '13'
        f =  mock()
        Fact.should_receive(:[]).with(fact_id).and_return(f)

        channel_id = '37'
        channel = mock()
        channel.should_receive(:add_fact).with(f)
        Channel.should_receive(:[]).with(channel_id).and_return(channel)

        interactor = AddFactToChannelInteractor.new fact_id, channel_id, ability: relaxed_ability
        interactor.execute
      end
    end
  end
end
