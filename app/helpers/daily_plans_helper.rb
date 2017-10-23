module DailyPlansHelper

  def new_daily_plan_renderer(daily_plan)
    renderer = DailyPlanRenderer.new(daily_plan)
    renderer.parse
    renderer
  end

  class DailyPlanRenderer
    include MarkdownHelper
    attr_reader :content, :nav_links, :preview

    def initialize(daily_plan)
      @daily_plan = daily_plan
    end

    def parse
      markdown = markdownify(@daily_plan.description)
      doc = Nokogiri::HTML::DocumentFragment.parse(markdown)

      index = 0
      @nav_links = []
      doc.css("h1,h2,h3,h4,h5,h6").each do |element|
        anchor = Nokogiri::XML::Node.new "a", doc
        anchor[:class] = "anchor"
        anchor[:name] = "anchor-#{index}"
        if element.children.present?
          element.children.first.add_previous_sibling(anchor)
        else
          element.add_next_sibling(anchor)
        end
        @nav_links << {name: "anchor-#{index}", text: element.text.strip}
        index += 1
      end
      @content = doc.to_html.html_safe
      @preview = doc.to_html.truncate(500).html_safe
    end

    def past?
      @daily_plan.date < Date.current
    end

    def today?
      @daily_plan.date == Date.current
    end

    def css_class
      if today?
        "text-danger"
      elsif past?
        "text-muted"
      end
    end

  end

end
