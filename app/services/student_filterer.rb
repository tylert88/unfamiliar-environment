class StudentFilterer

  def self.filter_from_params(students, params)

    case true
    when params[:cohort_id].present?
      return students.select { |student| student.current_cohort.id == params[:cohort_id].to_i }
    when params[:location].present?
      profile_user_ids = EmploymentProfile.where(
        "preferred_locations like ?",
        "%#{params[:location]}%"
      ).pluck(:user_id)
      return students.select { |student| profile_user_ids.include?(student.id) }
    when params[:status] == 'available'
      students.reject do |student|
        student.employments.select(&:active).present?
      end.sort_by do |student|
        [student.first_name, student.last_name]
      end
    when params[:status] == 'hired'
      students.select do |student|
        student.employments.select(&:active).present?
      end.sort_by do |student|
        [student.first_name, student.last_name]
      end
    else
      students.sort_by do |student|
        [
          student.employments.select(&:active).present? ? 1 : 0,
          student.first_name.downcase,
          student.last_name.downcase,
        ]
      end
    end
  end
end
