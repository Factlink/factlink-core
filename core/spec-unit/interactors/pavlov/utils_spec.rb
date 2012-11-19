describe Pavlov::Utils do
  subject do
    o = Object.new
    o.extend Pavlov::Utils
  end

  describe :hash_with_index do
    it "wraps its input in a hash, with as index the id of the objects in the array" do
      mocklist = [
          mock('foo', id: 1),
          mock('bar', id: 2)
      ]

      wrapped_mock_list = {
        1 => mocklist[0],
        2 => mocklist[1]
      }

      result = subject.hash_with_index(:id, mocklist)
      expect(result).to eq wrapped_mock_list
    end
  end
end
