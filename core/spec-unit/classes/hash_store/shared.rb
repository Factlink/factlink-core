shared_examples_for 'a hash store' do
  it 'can store a hash' do
    subject['someplace'].set({a: 'hash'})
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
    it "is for values which have not been set" do
      expect(subject['not set'].value?).to be_false
    end
    it "is true for values which are set" do
      subject['set'].set({some: 'hash'})
      expect(subject['set'].value?).to be_true
    end
  end

  it "supports multiple values for the key" do
    subject['foo','bar'].set({ some: 'hash' })
    expect(subject['foo','bar'].get).to eq({ some: 'hash' })
  end
end
