class OneOnOneScheduler

  attr_reader :students, :instructors, :appointments

  def initialize(students, instructors: [], start_time: '1:00pm', end_time: '4:45pm', start_date: Date.current)
    @start_date = start_date
    @students = students
    @instructors = instructors
    @start_time = start_time
    @end_time = end_time
  end

  def generate_schedule
    date = @start_date
    current_students = students.to_a.dup
    start_index = self.class.all_times.index(@start_time)
    end_index = self.class.all_times.index(@end_time)
    times = self.class.all_times[start_index..end_index]

    @appointments = []
    until current_students.empty?
      times.each do |time|
        instructors.each do |instructor|
          student = current_students.sample
          if student
            current_students.delete(student)
            @appointments << OpenStruct.new(
              date: date,
              instructor: instructor,
              student: student,
              time: time
            )
          else
            break
          end
        end
      end
      date += 1.day
    end
  end

  def self.all_times
    %w(
      9:00am
      9:15am
      9:30am
      9:45am
      10:00am
      10:15am
      10:30am
      10:45am
      11:00am
      11:15am
      11:30am
      11:45am
      1:00pm
      1:15pm
      1:30pm
      1:45pm
      2:00pm
      2:15pm
      2:30pm
      2:45pm
      3:00pm
      3:15pm
      3:30pm
      3:45pm
      4:00pm
      4:15pm
      4:30pm
      4:45pm
      5:00pm
      5:15pm
      5:30pm
      5:45pm
      6:00pm
      6:15pm
      6:30pm
      6:45pm
      7:00pm
    )
  end

end
