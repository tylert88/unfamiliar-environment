module NavHelper

  def user_links(user)
    [
      {text: "Learning Experiences", url: user_learning_experiences_path(user) },
      {text: "Performances", url: user_performances_path(user) },
      {text: "Expectations", url: user_expectations_path(user) },
      {text: "Projects", url: user_projects_path(user) },
      {text: "Add Employment", url: new_user_employment_path(user, cohort_id: params[:cohort_id]) },
      {text: "Employment Profile", url: user_employment_profile_path(user, cohort_id: params[:cohort_id]) },
      {text: "Public Profile", url: public_student_path(user) },
      {text: "Job Activities", url: user_job_activities_path(user) },
      {text: "Tracker Stats", url: user_tracker_statuses_path(user, cohort_id: params[:cohort_id]), class: "btn btn-info" },
      {text: "Edit", url: edit_user_path(user, cohort_id: params[:cohort_id]), class: "btn btn-info" },
      {text: "Student Dashboard (Instructor View)", url: student_dashboard_user_path(user), class: "btn btn-info" },
    ].map{|h| OpenStruct.new(h) }
  end

  def main_menu_links(target = :rails)
    links = {
      'Curriculums' => curriculums_url,
      'Class Projects' => class_projects_url,
      'Users' => users_url,
      'Enrollments' => enrollments_url,
      'Assessments' => assessments_url,
      'Campuses' => campuses_url,
      'Courses' => courses_url,
      'All Job Activities' => all_job_activities_url,
      'Timeline' => timelines_url,
      'Videos' => videos_path,
    }
    links
  end

  def student_link_groups(user)
    cohort = user.current_cohort
    links = {}
    class_work = {}
    if cohort.curriculum_id
      class_work["Learning Experiences"] = user_learning_experiences_path(user)
      class_work["Performance"] = user_performances_url(user)
    end

    links.merge(
      "Daily Plans" => cohort_daily_plans_url(cohort),
      "Class Work" => class_work.merge(
        "Exercises" => cohort_exercises_url(cohort),
        "Projects" => user_projects_url(user, cohort_id: cohort.id),
        "Writeups" => cohort_writeups_url(cohort),
        "Pair Bingo" => cohort_pairings_url(cohort),
        "Action Plan" => cohort_action_plan_entries_url(cohort),
        "Stories" => user_epics_url(user),
        "Tracker Stats" => user_tracker_statuses_url(user, cohort_id: cohort),
        "Assessments" => user_taken_assessments_url(user),
        "Expectations" => user_expectations_url(user),
        "Mentorship" => cohort_student_mentorships_url(cohort, user),
        "Assignment Submissions" => cohort_assignment_submissions_url(cohort),
        "ZPD Responses" => cohort_zpd_responses_url(cohort),
        "Snippets" => cohort_student_snippets_url(cohort)
      ),
      "Placement" => {
        "Employment Profile" => user_employment_profile_url(user),
        "Job Activities" => user_job_activities_url(user),
      },
      "Info" => {
        "Students" => cohort_students_url(cohort),
        "Class Details" => cohort_info_url(cohort),
        "Prereqs" => cohort_prereqs_url(cohort),
      },
      "Mentees" => mentor_url(user)
    )
  end

  def student_links_for_api(user)
    result = []
    student_link_groups(user).map do |key, value|
      entry = {text: key}
      if value.is_a?(Hash)
        entry[:urls] = value.map do |text, url|
          {text: text, url: url}
        end
      else
        entry[:url] = value
      end
      result << entry
    end
    result
  end

  def student_tab_renderers(user)
    tab_renderers_for_groups(student_link_groups(user))
  end

  # ----------------------------------

  def instructor_link_groups(cohort)
    link_groups = {
      "Students" => {
        "Students" => cohort_path(cohort),
        "Performance" => cohort_performances_path(cohort),
        "Action Plans" => instructor_cohort_action_plans_path(cohort),
        "Projects" => instructor_cohort_projects_path(cohort),
        "Social Links" => social_cohort_path(cohort),
        "Mentorships" => mentorships_cohort_path(cohort),
        "Assessments" => cohort_given_assessments_path(cohort),
      },
      "Daily Plans" => {
        "Today's Plan" => today_cohort_daily_plans_path(cohort),
        "All Plans" => cohort_daily_plans_path(cohort),
      },
      "Class" => {
        "Exercises" => instructor_cohort_cohort_exercises_path(cohort),
        "1-on-1 Schedule" => one_on_ones_cohort_path(cohort),
        "Writeup Topics" => instructor_cohort_writeup_topics_path(cohort),
        "Pair Rotations" => cohort_pair_rotations_path(cohort),
        "Random Pairs" => random_cohort_pair_rotations_path(cohort),
        "Assignments" => instructor_cohort_assignments_path(cohort),
        "ZPD Responses" => instructor_cohort_zpd_responses_path(cohort),
        "Snippets" => instructor_cohort_snippets_path(cohort),
      },
      "Student Facing" => {
        "Writeups" => cohort_writeups_path(cohort),
        "Pair Bingo" => cohort_pairings_path(cohort),
        "Action Plan" => cohort_action_plan_entries_path(cohort),
        "Students" => cohort_students_path(cohort),
        "Class Details" => cohort_info_path(cohort),
        "Prereqs" => cohort_prereqs_path(cohort),
      },
      "Setup" => {
        "Edit" => edit_cohort_path(cohort),
        "Staffings" => cohort_staffings_path(cohort),
        "Tracker Accounts" => instructor_cohort_tracker_accounts_path(cohort),
        "Import" => cohort_imports_path(cohort),
        "Greenhouse" => cohort_applications_path(cohort),
      },
    }

    class_projects = Epic
      .joins(:cohort_epics, :class_project)
      .references(:cohort_epics, :class_project)
      .where(cohort_epics: {cohort_id: cohort})
      .order('class_projects.name')
      .map(&:class_project)

    class_projects.each do |class_project|
      link_groups['Students']["#{class_project.name} Acceptance"] = acceptance_cohort_path(cohort, class_project_id: class_project.id)
    end
    link_groups
  end

  def instructor_tab_renderers(cohort)
    tab_renderers_for_groups(instructor_link_groups(cohort))
  end

  def tab_renderers_for_groups(link_groups)
    link_groups.map do |key, value|
      if value.is_a?(Hash)
        LinkGroupRenderer.new(self, key, value)
      else
        LinkRenderer.new(self, key, value)
      end
    end
  end

  class LinkGroupRenderer
    attr_reader :view_context
    private :view_context
    delegate :content_tag, :link_to, to: :view_context

    def initialize(view_context, name, links)
      @view_context = view_context
      @name = name
      @links = links
    end

    def render
      content_tag :li, class: "dropdown" do
        link = link_to "#", data: {toggle: "dropdown"}, class: "dropdown-toggle" do
          @name.html_safe + content_tag(:span, nil, class: "caret")
        end

        list_items = @links.map do |text, path|
          content_tag :li, link_to(text, path)
        end

        link + content_tag(:ul, list_items.join.html_safe, class: "dropdown-menu", role: "menu")
      end
    end
  end

  class LinkRenderer
    attr_reader :view_context
    private :view_context
    delegate :nav_item, to: :view_context

    def initialize(view_context, text, path)
      @view_context = view_context
      @text = text
      @path = path
    end

    def render
      nav_item(@text, @path)
    end
  end

end
