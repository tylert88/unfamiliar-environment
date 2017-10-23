require "rails_helper"

describe UsersController do
  let!(:cohort) { create_cohort }

  before do
    bypass_rescue
  end

  def sign_in_instructor
    sign_in(create_instructor)
  end

  describe "GET #new" do
    it "requires a user to be an instructor" do
      sign_in(create_user)
      expect{
        get 'new', :cohort_id => cohort.id
      }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        enrollment: { cohort_id: cohort.id },
        user: {
          first_name: "Johnny",
          last_name: "Smith",
          email: "email@example.com",
          role: :user,
        }
      }
    end

    it "requires a user to be an instructor" do
      sign_in(create_user)
      expect{
        post 'create', valid_params.merge(cohort_id: cohort.id)
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "allows instructors to creates a student" do
      sign_in_instructor

      expect { post( 'create', valid_params ) }.to change { User.count }.by 1

      user = User.last
      expect(user.first_name).to eq('Johnny')
      expect(user.last_name).to eq('Smith')
      expect(user.email).to eq('email@example.com')
      expect(user.cohorts).to include(cohort)
    end

    it "allows instructors to creates instructors" do
      sign_in_instructor

      expect {
        post( 'create', {
          enrollment: { cohort_id: "" },
          user: {
            first_name: "Johnny",
            last_name: "Smith",
            email: "email@example.com",
            role: :user,
          }
        })
      }.to change { User.count }.by 1

      user = User.last
      expect(user.first_name).to eq('Johnny')
      expect(user.last_name).to eq('Smith')
      expect(user.email).to eq('email@example.com')
    end

    it "sends an email to the user inviting them if specified" do
      sign_in_instructor

      expect {
        post(
          'create',
          valid_params.merge(
            cohort_id: cohort.id,
            send_welcome_email: 1,
          )
        )
      }.to change { ActionMailer::Base.deliveries.size }.by 1

      created_email = ActionMailer::Base.deliveries.last
      expect(created_email.to).to eq ['email@example.com']
    end

    it 'does not send an email when creation fails' do
      ActionMailer::Base.deliveries.clear

      post 'create', :cohort_id => cohort.id, :student => {}

      expect(ActionMailer::Base.deliveries.size).to eq(0)
    end
  end
end
