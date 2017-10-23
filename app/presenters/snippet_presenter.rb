class SnippetPresenter
	attr_accessor :snippet, :student_snippet
	def initialize(snippet, current_user)
		@snippet = snippet
		@student_snippet = StudentSnippet.find_by(user_id: current_user.id, snippet_id: snippet.id)
	end
end