class Pairing < ActiveRecord::Base

  belongs_to :pair, class_name: "User", foreign_key: :pair_id
  belongs_to :user

  validates :paired_on, presence: true
  validates :feedback, presence: true
  validates :pair,
            presence: true,
            uniqueness: {scope: [:user_id, :paired_on], message: "has already been given feedback for this date"}
  validates :user, presence: true

  def self.for_user(user)
    from_user = where(user_id: user)
    to_user = where(pair_id: user).map(&:user)
    {
      done: from_user.map(&:pair),
      pending: to_user - from_user.map(&:pair)
    }
  end

end
