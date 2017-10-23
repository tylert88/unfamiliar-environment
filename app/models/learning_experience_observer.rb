class LearningExperienceObserver < ActiveRecord::Observer
  include UserSessionHelper
  def after_create(learning_experience)
    CurriculumNotification.create!(user_id: learning_experience.user_id, resource_type: learning_experience.class.to_s, resource_id: learning_experience.id, resource_name: learning_experience.name, status: 0, curriculum_id: learning_experience.curriculum.id)
  end

  def after_update(learning_experience)
    CurriculumNotification.create!(user_id: learning_experience.user_id, resource_type: learning_experience.class.to_s, resource_id: learning_experience.id, resource_name: learning_experience.name, status: 1, curriculum_id: learning_experience.curriculum.id)
  end
end
