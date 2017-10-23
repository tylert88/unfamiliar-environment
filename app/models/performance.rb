class Performance < ActiveRecord::Base

  enum status: [ :unstarted, :scheduled, :in_progress, :submitted ]

  belongs_to :user
  belongs_to :objective
  belongs_to :updator, class_name: 'User', foreign_key: :updator_id

  validates :user, presence: true
  validates :objective, presence: true, uniqueness: {scope: :user_id}
  validates :updator, presence: true
  validates :score, presence: true, numericality: true

  before_validation do
    self.score = 0 if score.blank?
  end

  def update_score(user, score)
    self.updator = user
    self.score = score
    save
  end

  def move_to_next_status!(current_status)
    return if current_status != status
    keys = self.class.statuses.keys.to_a
    index = keys.index(current_status)
    new_status = keys[index + 1] || keys[0]
    update!(status: new_status)
  end
end
