class EmploymentProfile < ActiveRecord::Base

  enum status: [ :hidden, :visible ]

  belongs_to :user
  validates :user, presence: true, uniqueness: true
  validates :status, presence: true

  def is_complete_for_index_page?
    self.looking_for.present? && self.visible?
  end
end
