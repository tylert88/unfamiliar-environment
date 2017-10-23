class StudentStorySerializer < ActiveModel::Serializer
  attributes(*StudentStory.column_names)

  has_one :story
end
