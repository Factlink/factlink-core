require 'spec_helper'

describe UsernameGenerator do
  describe '#generate_from' do
    it 'transforms a name into a slug' do
      name = 'Jan Paul Posma'

      expect(subject.generate_from(name)).to eq 'jan.paul.posma'
    end

    it 'replaces - with .' do
      name = 'Jean-Paul'

      expect(subject.generate_from(name)).to eq 'jean.paul'
    end

    it 'takes a maximum length into account' do
      name = 'Jan Paul Posma'
      max_length = 3

      expect(subject.generate_from(name, max_length)).to eq 'jan'
    end

    it 'adds some random number if the initial slug is invalid' do
      name = 'Jan Paul Posma'

      result = subject.generate_from name do |username|
        username != 'jan.paul.posma'
      end

      expect(result).to match /\Ajan.paul.posma.\d{5}\Z/
    end

    it 'takes into account the maximum length with the random number' do
      name = 'Jan Paul Posma'
      max_length = name.size

      result = subject.generate_from name, max_length do |username|
        username != 'jan.paul.posma'
      end

      expect(result).to match /\Ajan.paul.\d{5}\Z/
    end

    it 'returns a random string until the username is valid' do
      name = 'Jan Paul Posma'
      max_length = 10

      n = 0
      result = subject.generate_from name, max_length do |username|
        n = n + 1

        n > 90
      end

      expect(result).to_not match /posma/
      expect(result).to match /\A[a-z0-9\.]{10}\Z/
    end

    it "doesn't loop infinitely" do
      name = 'Jan Paul Posma'
      max_length = 10

      expect do
        subject.generate_from(name, max_length){false}
      end.to raise_error
    end
  end
end
