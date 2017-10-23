require 'rails_helper'
require 'pp'

describe PairRotation do
  describe '.round_robin' do

    it 'returns an array of valid pair rotations from a round-robin' do
      user_ids = [1,2,3,4]

      rotations = PairRotation.round_robin(user_ids)

      expect(rotations).to eq([
        [[1,3], [4,2]],
        [[1,2], [3,4]],
        [[1,4], [2,3]],
      ])
    end

    it 'returns nil for sets with odd lengths' do
      user_ids = [1,2,3]

      rotations = PairRotation.round_robin(user_ids)

      expect(rotations).to eq([
        [[1,3], [nil,2]],
        [[1,2], [3,nil]],
        [[1,nil], [2,3]],
      ])
    end
  end
end
