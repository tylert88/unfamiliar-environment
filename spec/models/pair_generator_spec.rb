require 'spec_helper'
require_relative "../../app/models/pair_generator"

describe PairGenerator do

  let(:students) {
    [
        1,
        2,
        3,
        4,
        5,
        6
    ]
  }

  describe "#random_pairs" do
    it "returns an array of arrays of pairs of students" do
      two_students = [1, 2]

      pair_generator = PairGenerator.new(two_students)
      pairings = pair_generator.random_pairs

      expect(pairings.first).to match_array(two_students)
    end

    it "includes all of the students" do
      pair_generator = PairGenerator.new(students)
      result = pair_generator.random_pairs

      expect(result.length).to eq(3)
      result.each do |pair|
        expect(students).to include(pair.first)
        expect(students).to include(pair.last)
      end
      expect(result.flatten).to match_array(students)
    end

    it "returns nil for the second student if there's an odd number" do
      students.delete(students.last)

      pair_generator = PairGenerator.new(students)
      result = pair_generator.random_pairs
      expect(result.length).to eq(3)
      expect(result.last.last).to be_nil
    end

    it "doesn't return the same results when called multiple times" do
      pair_generator = PairGenerator.new(students)

      result1 = pair_generator.random_pairs
      result2 = pair_generator.random_pairs

      expect(result1).to_not eq(result2)
    end
  end
end