shared_examples_for 'a nested hash store' do
  it 'can store a hash' do
    subject['someplace'] = {a: 'hash'}
  end

  it "can retrieve a stored hash" do
    subject['someplace'] = { some: 'hash' }
    expect(subject['someplace'].get).to eq({ some: 'hash' })
  end

  it "can store and retrieve multiple values" do
    subject['someplace'] = { some: 'hash' }
    subject['someotherplace'] = { some: 'other hash' }

    expect(subject['someplace'].get).to eq({ some: 'hash' })
    expect(subject['someotherplace'].get).to eq({ some: 'other hash' })
  end

  describe "#value?" do
    it "is for values which have not been set" do
      expect(subject['not set'].value?).to be_false
    end
    it "is true for values which are set" do
      subject['set'] = {some: 'hash'}
      expect(subject['set'].value?).to be_true
    end
  end

  it "supports setting nested values" do
    subject['foo']['bar'] = { some: 'nested hash' }
    expect(subject['foo']['bar'].get).to eq({ some: 'nested hash' })
  end
end
