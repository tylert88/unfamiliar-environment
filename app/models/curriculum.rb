class Curriculum < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {scope: :version}
  validates :version, presence: true
  validates :description, presence: true

  has_many :standards, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :objectives, through: :standards
  has_many :learning_experiences, dependent: :destroy
end
