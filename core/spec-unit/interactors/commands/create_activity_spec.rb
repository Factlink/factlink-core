require_relative '../../../app/interactors/commands/create_activity.rb'

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
    activity_object = mock()
    command = Commands::CreateActivity.new graph_user, action, activity_subject, activity_object
    command.should_not be_nil
  end

  describe '.execute' do
    it 'correctly' do
      action = :test
      activity_subject = mock()
      activity_object = mock()
      command = Commands::CreateActivity.new graph_user, action, activity_subject, activity_object
      Activity.should_receive(:create).with(user: graph_user, action: action, subject: activity_subject, object: activity_object )

      command.execute
    end
  end
end
