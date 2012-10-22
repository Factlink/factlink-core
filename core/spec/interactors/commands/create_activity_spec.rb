require File.expand_path('../../../../app/interactors/commands/create_activity.rb', __FILE__)

describe Commands::CreateActivity do
  before do
    stub_const('CanCan::AccessDenied', Class.new(StandardError))
    stub_const('Activity', Class.new)
  end

  it 'initializes correctly' do
    user = mock('user',{:id => 1})
    action = :test
    subject = mock()
    command = Commands::CreateActivity.new user, action, subject, :current_user => user

    command.should_not be_nil
  end

  it 'gives a not authorized exception, when the current_user is not equal to the user' do
    user = mock('user', :id => 1)
    current_user = mock('current_user', :id => 2)
    action = :test
    subject = mock()
    expect{ Commands::CreateActivity.new user, action, subject, :current_user => current_user }.
      to raise_error(CanCan::AccessDenied, 'Unauthorized')
  end

  describe '.execute' do
    it 'correctly' do
      user = mock('user',{:id => 1})
      action = :test
      subject = mock()
      command = Commands::CreateActivity.new user, action, subject, :current_user => user
      Activity.should_receive(:create).with(user: user, action: action, subject: subject, :object => nil )

      command.execute
    end
  end
end
