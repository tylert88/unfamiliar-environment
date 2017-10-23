class Video < ActiveRecord::Base

  validates :title, presence: true, uniqueness: {case_sensitive: false}
  validates :vimeo_id, presence: true, uniqueness: true

end
