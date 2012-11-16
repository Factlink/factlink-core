require File.expand_path('../../../../app/interactors/fact_disbelievers_interactor.rb', __FILE__)

describe FactDisbelieversInteractor do
  it 'initializes correctly' do
    interactor = FactDisbelieversInteractor.new 1, 0, 3, current_user: mock
    interactor.should_not be_nil
  end

  it 'gives an authorized error when there isn''t a logged in user' do
    expect { FactDisbelieversInteractor.new 1, 0, 3 }.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  describe '.execute' do
    before do
      stub_const('Queries', Class.new)
      stub_const('Queries::FactInteractingUsers', Class.new)
    end

    it 'correctly' do
      fact_id = 1
      skip = 0
      take = 0
      user = mock()
      query = mock()
      u1 = mock()
      Queries::FactInteractingUsers.should_receive(:new).with(fact_id, skip, take, 'disbelieves', current_user: user).and_return(query)
      query.should_receive(:execute).and_return({users: [u1], total: 1})

      results = FactDisbelieversInteractor.perform fact_id, skip, take, current_user: user

      results[:total].should eq 1
      results[:users].should eq [u1]
    end
  end
end
