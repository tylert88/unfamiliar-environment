class Instructor::SnippetsController < InstructorRequiredController
	def index
		@snippets = Snippet.where(cohort_id: @cohort.id)
	end

	def new
		@snippet = Snippet.new
	end

	def create
		@snippet = Snippet.new(snippet_params.merge(cohort_id: params[:cohort_id]))
		if @snippet.save
			redirect_to instructor_cohort_snippet_path(@cohort, @snippet), notice: "Snippet successfully created"
		else
			render :new
		end
	end

	def show
		@snippet = Snippet.find(params[:id])
		@student_snippets = StudentSnippet.where(snippet_id: @snippet.id)
	end

	private

	def snippet_params
		params.require(:snippet).permit(:name)
	end
end
