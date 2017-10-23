module StudentChallengesHelper
  def format_user_id(user)
    user.full_name.gsub(" ", "").downcase + user.id.to_s
  end

  def format_progress_bar(percent)
    if percent == 100
      progress_class = "progress-bar-success"
      bar_width = percent
    elsif percent == 0.0
      progress_class = "progress-bar-danger"
      bar_width = "1"
    else
      progress_class = "progress-bar-warning"
      bar_width = percent
    end

    "<div class='progress'>
      <div class='challenge-progress progress-bar #{progress_class}' role='progressbar' aria-valuenow='80' aria-valuemin='0' aria-valuemax='100' style='width: #{bar_width}%'>
        <span class='sr-only'>80% Complete (danger)</span>
      </div>
    </div>".html_safe
  end
end
