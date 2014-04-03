require 'active_support/inflector/transliterate'
require_relative '../../../app/classes/username_generator'

describe UsernameGenerator do
  describe '#generate_from' do
    it 'transforms a name into a slug' do
      name = 'Jan   Paul   Posma'

      expect(subject.generate_from(name)).to eq 'jan_paul_posma'
    end

    it 'replaces - with _' do
      name = 'Jean-Paul'

      expect(subject.generate_from(name)).to eq 'jean_paul'
    end

    it 'strips crazy characters' do
      name = "Crazy \u1234 name"

      expect(subject.generate_from(name)).to eq 'crazy_name'
    end

    it 'takes a maximum length into account' do
      name = 'Jan Paul Posma'
      max_length = 3

      expect(subject.generate_from(name, max_length)).to eq 'jan'
    end

    it 'adds some random number if the initial slug is invalid' do
      name = 'Jan Paul Posma'

      result = subject.generate_from name do |username|
        username != 'jan_paul_posma'
      end

      expect(result).to match /\Ajan_paul_posma_\d+\z/
    end

    it 'takes into account the maximum length with the random number' do
      name = 'Jan Paul Posma'
      max_length = name.size

      result = subject.generate_from name, max_length do |username|
        username != 'jan_paul_posma'
      end

      expect(result).to match /\Ajan_paul_?p?o?s?_\d+\z/
    end

    it 'tries random numbers for 100 times until the username is valid' do
      name = 'Jan Paul Posma'

      n = 0
      result = subject.generate_from name do |username|
        n = n + 1

        n > 90
      end

      expect(result).to match /\Ajan_paul_posma_\d+\z/
    end

    it 'returns a random string until the username is valid' do
      name = 'Jan Paul Posma'
      max_length = 10

      n = 0
      result = subject.generate_from name, max_length do |username|
        n = n + 1

        n > 190
      end

      expect(result).to_not match /posma/
      expect(result).to match /\A[a-z0-9_]{10}\z/
    end

    it "doesn't loop infinitely" do
      name = 'Jan Paul Posma'
      max_length = 10

      expect do
        subject.generate_from(name, max_length) { false }
      end.to raise_error
    end
  end
end
