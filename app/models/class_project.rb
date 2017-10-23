class ClassProject < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, uniqueness: {case_sensitive: false}
  has_many :epics, dependent: :destroy
  has_many :student_stories, dependent: :destroy

  def self.ordered
    order('lower(name)')
  end

end
