require "rails_helper"

describe ZpdResponse do
  describe ".gather_data_for_user" do
    it "returns json data for a user's zpd responses" do
      ZpdResponse.destroy_all
      user = create_user
      create_zpd_response(user_id: user.id, response: 0, date: Date.today)

      expect(ZpdResponse.gather_data_for_user(user.id)).to eq [{label: "Too Easy!", response: 0, count: 1}].to_json

      create_zpd_response(user_id: user.id, response: 1, date: ZpdResponse.last.date + 1)

      expect(ZpdResponse.gather_data_for_user(user.id)).to eq [{label: "Too Easy!", response: 0, count: 1}, {label: "In My ZPD", response: 1, count: 1}].to_json

      create_zpd_response(user_id: user.id, response: 2, date: ZpdResponse.last.date + 1)

      expect(ZpdResponse.gather_data_for_user(user.id)).to eq [{label: "Too Easy!", response: 0, count: 1}, {label: "In My ZPD", response: 1, count: 1}, {label: "Too Challenging", response: 2, count: 1}].to_json
    end
  end

  describe ".for_cohort" do
    it "returns ZpdResponses for a cohort" do
      user = create_user
      cohort = create_cohort
      create_enrollment(user_id: user.id, cohort_id: cohort.id)
      zpd_response = create_zpd_response(user_id: user.id)
      create_zpd_response

      expect(ZpdResponse.for_cohort(cohort)).to eq [zpd_response]
    end
  end

  describe ".build_zpd_repsonses" do
    it "builds a tree from responses" do
      user = create_user
      user2 = create_user
      zpd_response_one = create_zpd_response(user_id: user.id, date: Date.today, response: 0)
      create_zpd_response(user_id: user2.id, date: Date.today, response: 1)
      zpd_response_two = create_zpd_response(user_id: user.id, date: ZpdResponse.last.date + 1, response: 1)
      create_zpd_response(user_id: user2.id, date: zpd_response_two.date, response: 1)

      expect(ZpdResponse.build_zpd_responses(ZpdResponse.all)).to eq(
        [
          {
            date: zpd_response_one.date,
            count: 2,
            "Too Easy!" => 1,
            "In My ZPD" => 1,
            "Too Challenging" => 0
          },
          {
            date: zpd_response_two.date,
            count: 2,
            "Too Easy!" => 0,
            "In My ZPD" => 2,
            "Too Challenging" => 0
          }
        ]
      )
    end
  end
end
