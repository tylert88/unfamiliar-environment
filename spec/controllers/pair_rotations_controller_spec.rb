require 'rails_helper'

describe PairRotationsController do

  it "only shows rotations for the current cohort" do
    sign_in(create_instructor)

    cohort = create_cohort
    rotation_1 = create_pair_rotation(cohort: cohort, happened_on: 2.days.ago)
    rotation_2 = create_pair_rotation(cohort: cohort)
    rotation_3 = create_pair_rotation(cohort: create_cohort)

    get :index, cohort_id: cohort.to_param

    expect(response).to be_success
    expect(assigns(:assigned)).to eq([rotation_1])
    expect(assigns(:available)).to eq([rotation_2])
  end

end
