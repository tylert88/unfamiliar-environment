require 'rails_helper'

describe ImportsController do

  it "sends invitations to the set password screen when specified" do
    sign_in(create_instructor)

    cohort = create_cohort

    csv_text = CSV.generate do |csv|
      csv << ["first_name","last_name","email","city","state","address","phone"]
      csv << ["Joe","Example","joe@example.com","San Francisco","CA",nil,nil]
      csv << ["Jane","Example","jane@example.com","San Francisco","CA",nil,nil]
    end

    expect do
      expect do
        post :create, cohort_id: cohort.to_param, student_csv: csv_text, invitation_type: 'password'
      end.to change{ User.count }.by(2)
    end.to change{ ActionMailer::Base.deliveries.length }.by(2)

    user = User.find_by_email('jane@example.com')
    verifier = Rails.application.message_verifier('set_password').generate(user.id)
    expect(ActionMailer::Base.deliveries.last.body).to include(set_password_url(verifier))

    expect(response).to redirect_to(cohort_path(cohort))
  end

end
