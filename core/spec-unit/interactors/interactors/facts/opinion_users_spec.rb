require_relative '../../../../app/interactors/interactors/facts/opinion_users.rb'

describe Interactors::Facts::OpinionUsers do
  it 'initializes correctly' do
    interactor = Interactors::Facts::OpinionUsers.new 1, 0, 3, 'believes', current_user: mock
    interactor.should_not be_nil
  end

  it 'gives an authorized error when there isn''t a logged in user' do
    expect { Interactors::Facts::OpinionUsers.new 1, 0, 3, 'believes' }.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  describe '.call' do
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
      Queries::FactInteractingUsers.should_receive(:new).with(fact_id, skip, take, 'believes', current_user: user).and_return(query)
      query.should_receive(:call).and_return({users: [u1], total: 1})

      results = Interactors::Facts::OpinionUsers.perform fact_id, skip, take, 'believes', current_user: user

      results[:total].should eq 1
      results[:users].should eq [u1]
    end
  end
end
