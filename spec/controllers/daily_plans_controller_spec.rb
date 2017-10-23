require "rails_helper"

describe DailyPlansController do
  let!(:cohort) { create_cohort }

  before do
    bypass_rescue
  end

  describe "GET #new" do
    it "allows instructors" do
      sign_in(create_instructor)
      expect do
        get 'new', cohort_id: cohort.id
      end.to_not raise_error
    end

    it "does not allow the public" do
      get 'new', cohort_id: cohort.id
      expect(response).to redirect_to(root_path)
    end

    it "does not allow students" do
      sign_in(create_student)
      expect do
        get 'new', cohort_id: cohort.id
      end.to raise_error(Pundit::NotAuthorizedError)
    end
  end
end
