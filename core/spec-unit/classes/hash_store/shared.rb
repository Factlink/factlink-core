shared_examples_for 'a hash store' do
  it 'can store a hash' do
    subject['someplace'].set({a: 'hash'})
  end

  it "cannot store an empty hash" do
    expect do
      subject['someplace'].set({})
    end.to raise_error
  end

  it "can retrieve a stored hash" do
    subject['someplace'].set({ some: 'hash' })
    expect(subject['someplace'].get).to eq({ some: 'hash' })
  end

  it "can store and retrieve multiple values" do
    subject['someplace'].set({ some: 'hash' })
    subject['someotherplace'].set({ some: 'other hash' })

    expect(subject['someplace'].get).to eq({ some: 'hash' })
    expect(subject['someotherplace'].get).to eq({ some: 'other hash' })
  end

  describe "#value?" do
    it "is false for a value which has not been set" do
      expect(subject['not set'].value?).to be_false
    end
    it "is true for a value which is set" do
      subject['set'].set({some: 'hash'})
      expect(subject['set'].value?).to be_true
    end
  end

  it "supports multiple values for the key" do
    subject['foo','bar'].set({ some: 'hash' })
    expect(subject['foo','bar'].get).to eq({ some: 'hash' })
  end

  describe 'namespace' do
    it "doesn't write values when in another namespace" do
      store1 = described_class.new 'namespace1'
      store2 = described_class.new 'namespace2'

      store1['someplace'].set({some: 'hash'})

      expect(store2['someplace'].value?).to be_false
    end

    it "doesn't overwrite values when in another namespace" do
      store1 = described_class.new 'namespace1'
      store2 = described_class.new 'namespace2'

      store1['someplace'].set({some: 'hash'})
      store2['someplace'].set({some: 'other hash'})

      expect(store1['someplace'].get).to eq({some: 'hash'})
    end

    # it doesn't guarantee to give the same value for the same namespace
  end
end
