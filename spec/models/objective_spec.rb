require 'rails_helper'

describe Objective do

  it "does not allow objectives that start with 'learn', 'know' or 'understand' etc..." do
    objective = Objective.new(name: 'learn stuff')
    objective.valid?
    expect(objective.errors[:name]).to include("can't start with a non-measurable verb")
  end

  it "allows words like learn elsewhere in the objective" do
    objective = Objective.new(name: 'describe how to learn stuff')
    objective.valid?
    expect(objective.errors[:name]).to_not include("can't start with a non-measurable verb")
  end

end
