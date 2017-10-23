require 'rails_helper'

describe Pairing do

  describe ".for_user" do
    before do
      @cohort = create_cohort
      @current_user = create_student(@cohort)
      @fully_paired = create_student(@cohort)
      @awaiting_other = create_student(@cohort)
      @awaiting_current = create_student(@cohort)
      @other_user = create_student(@cohort)

      create_pairing(user: @current_user, pair: @fully_paired)
      create_pairing(user: @fully_paired, pair: @current_user)
      create_pairing(user: @current_user, pair: @awaiting_other)
      create_pairing(user: @awaiting_current, pair: @current_user)
    end

    it "returns a list of users who you have entered feedback for" do
      pairings = Pairing.for_user(@current_user)
      expect(pairings[:done].length).to eq(2)
      expect(pairings[:done]).to include(@fully_paired)
      expect(pairings[:done]).to include(@awaiting_other)
    end

    it "returns a list of users who are awaiting feedback" do
      pairings = Pairing.for_user(@current_user)
      expect(pairings[:pending]).to eq([@awaiting_current])
    end
  end

end
