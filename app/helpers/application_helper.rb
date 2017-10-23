module ApplicationHelper

  def all_users_typeahead_json
    User.all.map do |user|
      {
        id: user.id,
        full_name: user.full_name,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email
      }
    end.to_json
  end

  def current_name_or_classmate(user)
    if current_user.instructor? || user == current_user
      user.full_name
    else
      'Classmate'
    end
  end

  def nav_item(name, path, link_options: {}, active: false)
    active ||= current_page?(path)
    content_tag('li', :class => (active ? 'active' : nil)) do
      link_to(name, path, link_options)
    end
  end

  def page_header(title, &block)
    content_for(:title, title)
    html = '<div class="page-header">'
    if block
      html += content_tag :div, class: "pull-right" do
        capture(&block)
      end
    end
    html += content_tag(:h2, title)
    html += '</div>'
    html.html_safe
  end

  def cohort_timeline_json(cohorts)
    lines = []
    cohorts.each do |cohort|
      lines << "['#{cohort.campus.name}', '#{cohort.name}', new Date(#{cohort.start_date.year},#{cohort.start_date.month},#{cohort.start_date.day},0,0,0), new Date(#{cohort.end_date.year},#{cohort.end_date.month},#{cohort.end_date.day},0,0,0)]"
    end
    "[#{lines.join(",")}]"
  end

  def expectation_status_class(status)
    if status.on_track
      'panel-success'
    else
      'panel-danger'
    end
  end

  def progress_bar_class(num)
    case
    when num <= 33
      "progress-bar-danger"
    when num <= 66
      "progress-bar-warning"
    when num <= 100
      "progress-bar-success"
    end
  end

  def rigorous_progress_bar_class(num)
    case
    when num <= 50
      "progress-bar-danger"
    when num <= 99
      "progress-bar-warning"
    when num <= 100
      "progress-bar-success"
    end
  end

end
