require_relative '../../../app/classes/hash_store/entry.rb'

describe HashStore::Entry do
  describe '#value?' do
    it 'is false when backend returns nil' do
      backend = double get: nil
      entry = described_class.new(backend)

      expect(entry.value?).to be_false
    end

    it 'is true when backend returns a hash' do
      backend = double get: {some: 'hash'}
      entry = described_class.new(backend)

      expect(entry.value?).to be_true
    end
  end

  describe '#get' do
    it 'raises when backend has no value' do
      backend = double get: nil
      entry = described_class.new(backend)

      expect{entry.get}.to raise_error
    end

    it 'returns a hash of symbols' do
      backend = double get: {'some' => 'hash'}
      entry = described_class.new(backend)

      expect(entry.get).to eq({some: 'hash'})
    end

    it 'returns a hash with only strings as values' do
      backend = double get: {some: 3}
      entry = described_class.new(backend)

      expect(entry.get).to eq({some: '3'})
    end
  end

  describe '#set' do
    it 'calls backend.set with the given hash' do
      backend = double
      value   = {some: 'hash'}
      entry   = described_class.new(backend)

      backend.should_receive(:set).with(value)

      entry.set value
    end

    it 'raises when trying to set an empty hash' do
      entry = described_class.new(double)
      expect do
        entry.set({})
      end.to raise_error
    end
  end
end
