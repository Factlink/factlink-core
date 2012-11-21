require_relative '../../../app/interactors/queries/fact_interacting_users.rb'

describe Queries::FactInteractingUsers do

  it 'it initializes correctly' do
    query = Queries::FactInteractingUsers.new 1, 0, 3, 'believes'
    query.should_not be_nil
  end

  it 'it throws when initialized without a correct fact_id' do
    expect { Queries::FactInteractingUsers.new 'a', 0, 3, 'disbelieves'}.
      to raise_error(Pavlov::ValidationError, 'fact_id should be an integer.')
  end

  it 'it throws when initialized with a skip argument that is not an integer.' do
    expect { Queries::FactInteractingUsers.new 1, 'a', 3, 'doubts'}.
      to raise_error(Pavlov::ValidationError, 'skip should be an integer.')
  end

  it 'it throws when initialized with a take argument that is not an integer.' do
    expect { Queries::FactInteractingUsers.new 1, 0, 'b', 'doubts'}.
      to raise_error(Pavlov::ValidationError, 'take should be an integer.')
  end

  it 'it throws when initialized with a unknown opinion' do
    expect { Queries::FactInteractingUsers.new 1, 0, 3, 'W00T'}.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  describe '.execute' do

    before do
      stub_const 'Fact', Class.new
    end

    it "returns a user who believes the fact" do
      fact = mock(id: 1)
      Fact.should_receive(:[]).with(fact.id).and_return(fact)
      user = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      graph_user = mock(user: user)
      fact.should_receive(:people_believes).and_return([graph_user])

      result = Queries::FactInteractingUsers.execute(1, 0, 3, 'believes')

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it "returns a user who disbelieves the fact" do
      fact = mock(id: 1)
      Fact.should_receive(:[]).with(fact.id).and_return(fact)
      user = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      graph_user = mock(user: user)
      fact.should_receive(:people_disbelieves).and_return([graph_user])

      result = Queries::FactInteractingUsers.execute(1, 0, 3, 'disbelieves')

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it "returns a user who doubts the fact" do
      fact = mock(id: 1)
      Fact.should_receive(:[]).with(fact.id).and_return(fact)
      user = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      graph_user = mock(user: user)
      fact.should_receive(:people_doubts).and_return([graph_user])

      result = Queries::FactInteractingUsers.execute(1, 0, 3, 'doubts')

      expect(result[:total]).to eq 1
      expect(result[:users].first.id).to eq user.id
    end

    it "correctly skips and takes" do
      fact = mock(id: 1)
      Fact.should_receive(:[]).with(fact.id).and_return(fact)
      user1 = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      user2 = mock(id: 3, username: 'mijn username', name: 'Joop Bouwhuis' )
      user3 = mock(id: 4, username: 'mijn username', name: 'Joop Bouwhuis' )
      graph_user1 = mock(user: user1)
      graph_user2 = mock(user: user2)
      graph_user3 = mock(user: user3)
      fact.should_receive(:people_believes).and_return([graph_user1, graph_user2, graph_user3])

      result = Queries::FactInteractingUsers.execute(1, 1, 1, 'believes')

      expect(result[:total]).to eq 3
      expect(result[:users].size).to eq 1
      expect(result[:users].first.id).to eq user2.id
    end
  end
end
