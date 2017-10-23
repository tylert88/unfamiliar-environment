module CurriculumNotificationHelper
  def resource_link(curriculum_notification)
    case true
    when curriculum_notification.resource_type == "Objective"
      "/objectives/#{curriculum_notification.resource_id}"
    when curriculum_notification.resource_type == "Standard"
      "/standards/#{curriculum_notification.resource_id}"
    when curriculum_notification.resource_type == "LearningExperience"
      "/curriculums/#{LearningExperience.find(curriculum_notification.resource_id).curriculum.id}/learning_experiences/#{curriculum_notification.resource_id}"
    end
  end
end
