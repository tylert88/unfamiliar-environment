class WriteupComment < ActiveRecord::Base

  belongs_to :writeup
  belongs_to :user

  validates :user, presence: true
  validates :writeup, presence: true
  validates :body, presence: true

end
