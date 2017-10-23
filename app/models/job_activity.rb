class JobActivity < ActiveRecord::Base

  belongs_to :user
  validates :user, presence: true
  validates :company, presence: true

end
