require_relative '../../app/classes/hash_utils'

describe HashUtils do
  describe :hash_with_index do
    it "wraps its input in a hash, with as index the id of the objects in the array" do

      stublist = [
        double(id: 1),
        double(id: 2)
      ]

      wrapped_stub_list = {
        "1" => stublist[0],
        "2" => stublist[1]
      }

      result = described_class.hash_with_index(:id, stublist)
      expect(result).to eq wrapped_stub_list
    end
  end
end
