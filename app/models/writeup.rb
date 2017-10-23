class Writeup < ActiveRecord::Base

  belongs_to :user
  belongs_to :writeup_topic
  has_many :comments, class_name: 'WriteupComment'

  validates :user, presence: true
  validates :writeup_topic, presence: true, uniqueness: {scope: :user_id}

end
