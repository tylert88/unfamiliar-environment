class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :slug, :story_type

  has_one :epic
  has_one :class_project
end
