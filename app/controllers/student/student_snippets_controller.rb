class Student::StudentSnippetsController < ApplicationController
	def index
		@student_snippet = StudentSnippet.new
		@snippet_presenters = Snippet.where(cohort_id: @cohort.id).map { |snippet| SnippetPresenter.new(snippet, current_user) }
	end

	def show
		@student_snippet = StudentSnippet.find(params[:id])
		respond_to do |format|
			format.html {  render :show }
			format.json { render json: @student_snippet.to_json}
		end
	end

	def create
		@student_snippet = StudentSnippet.new(student_snippet_params.merge(user_id: current_user.id, body: ""))
		if @student_snippet.save
			redirect_to cohort_student_snippet_path(@cohort, @student_snippet)
		else
			flash[:alert] = "Something went wrong"
			redirect_to cohort_student_snippets_path(@cohort)
		end
	end

	def update
		@student_snippet = StudentSnippet.find(params[:id])
		if @student_snippet.update(update_student_snippet_params)
			redirect_to cohort_student_snippet_path(@cohort, @student_snippet), notice: "Updated"
		else
		end
	end

	private

	def student_snippet_params
		params.require(:student_snippet).permit(:snippet_id)
	end

	def update_student_snippet_params
		params.require(:student_snippet).permit(:body)
	end
end