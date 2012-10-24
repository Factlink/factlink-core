require File.expand_path('../../../../app/interactors/commands/create_activity.rb', __FILE__)

describe Commands::CreateActivity do
  let(:current_user) { mock('current_user', id: 2) }
  let(:graph_user)   { mock('user',id: 1, user_id: current_user.id) }
  let(:other_graph_user)   { mock('user',id: 1, user_id: current_user.id + 1)  }

  before do
    stub_const('Activity', Class.new)
  end

  it 'initializes correctly' do
    action = :test
    activity_subject = mock()
    command = Commands::CreateActivity.new graph_user, action, activity_subject, current_user: current_user
    command.should_not be_nil
  end

  it 'gives a not authorized exception, when the current_user is not equal to the user' do
    action = :test
    activity_subject = mock()
    expect{ Commands::CreateActivity.new other_graph_user, action, activity_subject, :current_user => current_user }.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  describe '.execute' do
    it 'correctly' do
      action = :test
      activity_subject = mock()
      command = Commands::CreateActivity.new graph_user, action, activity_subject, :current_user => current_user
      Activity.should_receive(:create).with(user: graph_user, action: action, subject: activity_subject, :object => nil )

      command.execute
    end
  end
end
