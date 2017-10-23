module EpicsHelper

  def epic_markdown(epic)
    string = "### gCamp Stories: #{epic.name}".html_safe
    string << "\n\n```\n"
    string << ['Type', 'Estimate', 'Current State', 'Labels', 'Story', 'Description'].to_csv
    epic.stories.each do |story|
      string << ['feature', 1,'unstarted',[epic.label, epic.category].reject(&:blank?).join(", "), story.title, story.description].to_csv
    end
    string << "\n```\n\n"
    string << epic.wireframes
    string
  end

end
