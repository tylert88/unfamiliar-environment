class Employment < ActiveRecord::Base

  belongs_to :user

  validates :user, presence: true

  scope :active, ->{ where(active: true) }

  def self.for_user(user)
    where(user_id: user)
  end

  def display_string
    public_description
  end

end
