require "rails_helper"

describe PublicController do
  describe "GET index" do
    context "filtering students" do
      it "filters students who are in the final half of their class with a complete and visible profile" do
        cohort_in_final_half = create_cohort(showcase: true, start_date:( Date.current - 180), end_date: (Date.current + 1))
        cohort_in_first_half = create_cohort(start_date: Date.current, end_date: Date.current + 180)
        create_student(cohort_in_first_half)
        student = create_student(cohort_in_final_half)
        create_employment_profile(user_id: student.id, looking_for: "Mentorship\n", bio: "Student bio", headline: "Jr. Ruby Developer")

        get :index

        expect(assigns(:students)).to eq [student]
      end

      it "filters students who do not have jobs that have completed the program with a complete and visible profile" do
        finished_cohort = create_cohort(showcase: true, start_date: (Date.current - 180), end_date: (Date.current - 1))
        student_with_job = create_student(finished_cohort)
        student_without_job = create_student(finished_cohort)
        create_employment_profile(user_id: student_without_job.id, looking_for: "Mentorship\n", bio: "Student bio", headline: "Jr. Ruby Developer")
        create_employment(user_id: student_with_job.id)

        get :index

        expect(assigns(:students)).to eq [student_without_job]
      end
    end
  end
end
