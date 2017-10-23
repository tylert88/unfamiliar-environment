class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :learning_experience
end
