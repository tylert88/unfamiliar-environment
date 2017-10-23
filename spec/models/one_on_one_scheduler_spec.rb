require 'rails_helper'

describe OneOnOneScheduler do
  describe '#generate_schedule' do

    it 'populates the appointments' do
      student = [User.new(first_name: "Student")]
      instructor = [User.new(first_name: "Instructor")]
      scheduler = OneOnOneScheduler.new(student, instructors: [instructor])
      scheduler.generate_schedule
      expect(scheduler.appointments.length).to eq(1)
    end

    it 'starts at the designated time' do
      student = [User.new(first_name: "Student"), User.new(first_name: "Student")]
      instructor = [User.new(first_name: "Instructor")]
      scheduler = OneOnOneScheduler.new(student, instructors: [instructor], start_time: '10:15am')
      scheduler.generate_schedule
      appointments = scheduler.appointments
      expect(appointments.first.time).to eq('10:15am')
      expect(appointments.second.time).to eq('10:30am')
    end

    it 'breaks things up by day' do
      student = [
        User.new(first_name: "Student"),
        User.new(first_name: "Student"),
        User.new(first_name: "Student"),
        User.new(first_name: "Student"),
      ]
      instructor = [User.new(first_name: "Instructor")]
      scheduler = OneOnOneScheduler.new(
        student,
        instructors: [instructor],
        start_time: '10:15am',
        end_time: '10:30am'
      )
      scheduler.generate_schedule
      appointments = scheduler.appointments

      expect(appointments[0].time).to eq('10:15am')
      expect(appointments[0].date).to eq(Date.current)

      expect(appointments[1].time).to eq('10:30am')
      expect(appointments[1].date).to eq(Date.current)

      expect(appointments[2].time).to eq('10:15am')
      expect(appointments[2].date).to eq(Date.current + 1.day)

      expect(appointments[3].time).to eq('10:30am')
      expect(appointments[3].date).to eq(Date.current + 1.day)
    end

  end
end
