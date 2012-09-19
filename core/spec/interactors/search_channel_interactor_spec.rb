require File.expand_path('../../../app/interactors/search_channel_interactor.rb', __FILE__)

describe "SearchChannelInteractor" do

  let(:relaxed_ability) do
    ability = mock()
    ability.stub can?: true
    ability
  end

  let(:fake_class) { Class.new }

  before do
    class User; end
    @user = User.new
    stub_const 'Topic', fake_class
    stub_const 'CanCan::AccessDenied', Class.new(Exception)
    stub_const 'Sunspot', fake_class
    stub_const 'Fact', fake_class
  end

  it 'initializes' do
    interactor = SearchChannelInteractor.new 'keywords', @user
    interactor.should_not be_nil
  end

  it 'raises when initialized with keywords that is not a string' do
    expect { interactor = SearchChannelInteractor.new nil, @user }.to raise_error
  end

  it 'raises when initialized with an empty keywords string' do
    expect { interactor = SearchChannelInteractor.new '', @user }.to raise_error
  end

  it 'raises when initialized with a user that is not a User.' do
    expect { interactor = SearchChannelInteractor.new 'keywords', nil }.to raise_error
  end

  describe :execute do
    it 'raises when executed without any permission' do
      keywords = "searching for this channel"
      ability = mock()
      ability.stub can?: false
      interactor = SearchChannelInteractor.new keywords, @user, ability: ability

      expect { interactor.execute }.to raise_error(CanCan::AccessDenied)
    end

    it 'executes correctly' do
      keywords = "searching for this channel"
      interactor = SearchChannelInteractor.new keywords, @user, ability: relaxed_ability
      internal_result = mock()
      Sunspot.should_receive(:search).
        with(Fact).
        and_return(internal_result)

      interactor.execute.should equal internal_result
    end

  end
end
