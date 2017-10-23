class StudentSnippet < ActiveRecord::Base
	belongs_to :user
	belongs_to :snippet

	validates :user_id, uniqueness: { scope: :snippet_id }
end
