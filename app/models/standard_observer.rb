class StandardObserver < ActiveRecord::Observer
  include UserSessionHelper
  def after_create(standard)
    CurriculumNotification.create!(user_id: standard.user_id, resource_type: standard.class.to_s, resource_id: standard.id, resource_name: standard.name, status: 0,curriculum_id: standard.curriculum.id)
  end

  def after_update(standard)
    CurriculumNotification.create!(user_id: standard.user_id, resource_type: standard.class.to_s, resource_id: standard.id, resource_name: standard.name, status: 1, curriculum_id: standard.curriculum.id)
  end
end
