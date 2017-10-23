require 'rails_helper'

describe ObjectiveMerger do

  describe "#merge" do

    let(:instructor) { create_instructor }

    let(:objective1) {
      create_objective(
        name: "objective 1",
        description: "desc1",
        guiding_questions: "guid1",
        resources: "res1",
        instructor_notes: "inst1",
      )
    }

    let(:objective2) {
      create_objective(
        name: "objective 2",
        standard: objective1.standard,
        description: "desc2",
        guiding_questions: "guid2",
        resources: "res2",
        instructor_notes: "inst2",
      )
    }

    let(:objective3) {
      create_objective(
        name: "objective 3",
        standard: objective1.standard,
        description: "desc3",
        guiding_questions: "guid3",
        resources: "res3",
        instructor_notes: "inst3",
      )
    }

    let(:student1) {create_student(create_cohort)}
    let(:student2) {create_student(create_cohort)}

    it "does nothing if there are no objectives" do
      merger = ObjectiveMerger.new([], "do stuff", instructor)

      expect do
        merger.merge
      end.to change{Objective.count}.by(0)

      expect(merger.new_objective).to be_nil
    end

    it "creates a new objective that contains the combined data from all of the given objectives" do

      merger = ObjectiveMerger.new(
        [objective1.id, objective2.id, objective3.id],
        "do stuff",
        instructor
      )

      expect { merger.merge }.to change{Objective.count}.by(-2)

      # objective names


      expect(merger.new_objective.standard).to eq(objective1.standard)
      expect(merger.new_objective.name).to eq("do stuff")
      expect(merger.new_objective.description).to eq("- objective 1\n- objective 2\n- objective 3\n\ndesc1\n\ndesc2\n\ndesc3")
      expect(merger.new_objective.guiding_questions).to eq("guid1\n\nguid2\n\nguid3")
      expect(merger.new_objective.resources).to eq("res1\n\nres2\n\nres3")
      expect(merger.new_objective.instructor_notes).to eq("inst1\n\ninst2\n\ninst3")
    end

    it "creates a new performance for each student, taking the highest score" do

      create_performance(user: student1, objective: objective1, score: 1)
      create_performance(user: student1, objective: objective2, score: 3)

      create_performance(user: student2, objective: objective1, score: 4)
      create_performance(user: student2, objective: objective2, score: 2)

      merger = ObjectiveMerger.new(
        [objective1.id, objective2.id],
        "do stuff",
        instructor
      )

      expect { merger.merge }.to change{Performance.count}.by(-2)

      objective = merger.new_objective

      performance1 = Performance.where(user_id: student1, objective_id: objective).first
      performance2 = Performance.where(user_id: student2, objective_id: objective).first

      expect(performance1.score).to eq(3)
      expect(performance1.updator).to eq(instructor)
      expect(performance2.score).to eq(4)
      expect(performance2.updator).to eq(instructor)
    end

    it "does everything in a transaction" do
      objective1 = create_objective(
          name: "objective 1",
          description: "desc1",
          guiding_questions: "guid1",
          resources: "res1",
          instructor_notes: "inst1",
        )

      objective2 = create_objective(
          name: "objective 2",
          standard: objective1.standard,
          description: "desc2",
          guiding_questions: "guid2",
          resources: "res2",
          instructor_notes: "inst2",
        )

      expect(Objective).to receive(:create!).and_raise("Blow up")

      merger = ObjectiveMerger.new(
        [objective1.id, objective2.id],
        "do stuff",
        instructor
      )

      expect do
        expect do
          expect(merger.merge).to equal(merger)
        end.to change{Objective.count}.by(0)
      end.to change{Performance.count}.by(0)

      expect(merger.message).to eq("Problem creating objective \"do stuff\": Blow up")
      expect(merger.success).to eq(false)
    end

  end

end
