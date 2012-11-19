require_relative '../../../app/interactors/queries/fact_interacting_users.rb'

describe Queries::FactInteractingUsers do

  it 'it initializes correctly' do
    query = Queries::FactInteractingUsers.new 1, 0, 3, 'believes'
    query.should_not be_nil
  end

  it 'it throws when initialized without a correct fact_id' do
    expect { Queries::FactInteractingUsers.new 'a', 0, 3, 'disbelieves'}.
      to raise_error(Pavlov::ValidationError, 'fact_id should be a integer.')
  end

  it 'it throws when initialized with a skip argument that is not a integer.' do
    expect { Queries::FactInteractingUsers.new 1, 'a', 3, 'doubts'}.
      to raise_error(Pavlov::ValidationError, 'skip should be a integer.')
  end

  it 'it throws when initialized with a take argument that is not a integer.' do
    expect { Queries::FactInteractingUsers.new 1, 0, 'b', 'doubts'}.
      to raise_error(Pavlov::ValidationError, 'take should be a integer.')
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
      interactions_reference = mock()
      fact.should_receive(:interactions).and_return(interactions_reference)
      user = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      disbelieve_user = mock()
      doubt_user = mock()
      interactions = [mock(action: 'disbelieves', user: mock(user: disbelieve_user)),
        mock(action: 'doubts', user: mock(user: doubt_user)),
        mock(action: 'believes', user: mock(user: user))]
      interactions_reference.should_receive(:below).with('inf',reversed: true).and_return(interactions)

      result = Queries::FactInteractingUsers.execute(1, 0, 3, 'believes')

      expect(result[:total]).to eq 1
      expect(result[:users].first).to eq user
    end

    it "returns a user who disbelieves the fact" do
      fact = mock(id: 1)
      Fact.should_receive(:[]).with(fact.id).and_return(fact)
      interactions_reference = mock()
      fact.should_receive(:interactions).and_return(interactions_reference)
      user = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      believe_user = mock()
      doubt_user = mock()
      interactions = [mock(action: 'believes', user: mock(user: believe_user)),
        mock(action: 'doubts', user: mock(user: doubt_user)),
        mock(action: 'disbelieves', user: mock(user: user))]
      interactions_reference.should_receive(:below).with('inf',reversed: true).and_return(interactions)

      result = Queries::FactInteractingUsers.execute(1, 0, 3, 'disbelieves')

      expect(result[:total]).to eq 1
      expect(result[:users].first).to eq user
    end

    it "returns a user who doubts the fact" do
      fact = mock(id: 1)
      Fact.should_receive(:[]).with(fact.id).and_return(fact)
      interactions_reference = mock()
      fact.should_receive(:interactions).and_return(interactions_reference)
      user = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      disbelieve_user = mock()
      believe_user = mock()
      interactions = [mock(action: 'believes', user: mock(user: believe_user)),
        mock(action: 'disbelieves', user: mock(user: disbelieve_user)),
        mock(action: 'doubts', user: mock(user: user))]
      interactions_reference.should_receive(:below).with('inf',reversed: true).and_return(interactions)

      result = Queries::FactInteractingUsers.execute(1, 0, 3, 'doubts')

      expect(result[:total]).to eq 1
      expect(result[:users].first).to eq user
    end

    it "correctly skips and takes" do
      fact = mock(id: 1)
      Fact.should_receive(:[]).with(fact.id).and_return(fact)
      interactions_reference = mock()
      fact.should_receive(:interactions).and_return(interactions_reference)
      user1 = mock(id: 2, username: 'mijn username', name: 'Joop Bouwhuis' )
      user2 = mock(id: 3, username: 'mijn username', name: 'Joop Bouwhuis' )
      user3 = mock(id: 4, username: 'mijn username', name: 'Joop Bouwhuis' )
      disbelieve_user = mock()
      interactions = [mock(action: 'disbelieves', user: mock(user: disbelieve_user)),
        mock(action: 'believes', user: mock(user: user1)),
        mock(action: 'believes', user: mock(user: user2)),
        mock(action: 'believes', user: mock(user: user3))]
      interactions_reference.should_receive(:below).with('inf',reversed: true).and_return(interactions)

      result = Queries::FactInteractingUsers.execute(1, 1, 1, 'believes')

      expect(result[:total]).to eq 3
      expect(result[:users].size).to eq 1
      expect(result[:users].first).to eq user2
    end
  end
end
