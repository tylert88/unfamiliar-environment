class ObjectiveObserver < ActiveRecord::Observer
  include UserSessionHelper
  def after_create(objective)
    CurriculumNotification.create!(user_id: objective.user_id, resource_type: objective.class.to_s, resource_id: objective.id, resource_name: objective.name, status: 0, curriculum_id: objective.standard.curriculum.id)
  end

  def after_update(objective)
    CurriculumNotification.create!(user_id: objective.user_id, resource_type: objective.class.to_s, resource_id: objective.id, resource_name: objective.name, status: 1, curriculum_id: objective.standard.curriculum.id)
  end
end
