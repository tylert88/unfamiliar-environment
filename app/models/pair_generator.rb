class PairGenerator
  def initialize(students, unpairable={})
    @students = students
  end

  def random_pairs
    original_students = @students.to_a.dup

    result = []

    while original_students.length > 0
      result << 2.times.map { original_students.delete(original_students.sample) }
    end

    result
  end
end
