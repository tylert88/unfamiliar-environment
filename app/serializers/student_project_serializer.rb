class StudentProjectSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :user_id,
    :class_project_id,
    :tracker_url,
    :production_url,
    :tracker_project_id
  )

  has_many :student_stories
  has_one :user
end
