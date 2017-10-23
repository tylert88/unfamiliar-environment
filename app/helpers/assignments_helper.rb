module AssignmentsHelper


  def submissions_rate(submissions,current_assignments)
  	submissions_hash = {}
  	
  	current_assignments.each do |current_assignment|
  	  submitted_assignments = 0
  	  submissions.where(assignment_id: current_assignment).each do |assignment|
  	   submitted_assignments +=1 if assignment.submitted == true
       submissions_hash[current_assignment] = submitted_assignments
	  end
    end

	submissions_hash
  end

  def non_submissions(submissions,current_assignments)

    non_submissions_hash = {}
  	
  	current_assignments.each do |current_assignment|
  	  students_list = []
  	  submissions.where(assignment_id: current_assignment).each do |assignment|
  	   students_list << assignment.user.first_name if assignment.submitted == false
       non_submissions_hash[current_assignment] = students_list
	  end

    end
	non_submissions_hash
  end

end