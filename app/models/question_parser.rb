class QuestionParser
  def initialize(html)
    @html = html
  end

  def questions
    doc = Nokogiri::HTML(@html)
    questions = []
    doc.css("input, textarea").each do |element|
      question_data = OpenStruct.new(
        id: element['id'],
        answer: element['data-answer'],
        bonus: element['data-bonus'],
        format: element['data-format'] || 'markdown',
      )
      question_data.text = get_question_text(element)
      questions << question_data
    end
    questions
  end

  private def get_question_text(element)
    current_node = element.parent && element.parent.previous_sibling
    until current_node.nil?
      if current_node.name == 'p'
        return current_node.text
      end
      current_node = current_node.previous_sibling
    end

    element.ancestors('li').css('p').first.try(:text)
  end

  def form_markdown(answer_hash = {})
    doc = Nokogiri::HTML(@html)
    doc.css("input, textarea").each do |element|
      field = Nokogiri::XML::Node.new element.name, doc
      if element.name.downcase == "input"
        field['value'] = answer_hash.fetch(element['id'], {})[:response]
      else
        field.content = answer_hash.fetch(element['id'], {})[:response]
      end
      field['id'] = element['id']
      field['name'] = "answers[#{element['id']}]"
      field['class'] = "form-control"
      field['style'] = element['style']
      field['rows'] = element['rows']
      field['cols'] = element['cols']
      element.add_next_sibling(field)
      element.remove
    end
    doc.css('body').children.to_html
  end

  def form_preview_markdown
    doc = Nokogiri::HTML(@html)
    doc.css("input, textarea").each do |element|
      field = Nokogiri::XML::Node.new element.name, doc
      field['class'] = "form-control"
      field['style'] = element['style']
      field['rows'] = element['rows']
      field['cols'] = element['cols']
      field['disabled'] = 'disabled'
      value = element['id']
      value += " (#{element['data-answer']})" if element['data-answer'].present?
      if element.name == "input"
        field['value'] = value
      else
        field.content = value
      end
      element.add_next_sibling(field)
      element.remove
    end
    doc.css('body').children.to_html
  end

  def display_markdown(replacements)
    doc = Nokogiri::HTML(@html)
    doc.css("input, textarea").each_with_index do |element, i|
      answer = replacements.fetch(element['id'], {})
      if answer[:notes].present?
        text_node = Nokogiri::XML::Node.new "a", doc
        text_node['class'] = "btn btn-warning btn-lg"
        text_node['tabindex'] = i
        text_node['data-trigger'] = 'focus'
        text_node['title'] = "Notes"
        text_node['data-toggle'] = "popover"
        text_node['data-content'] = answer[:notes]
      else
        text_node = Nokogiri::XML::Node.new "span", doc
        if answer[:score] == 0
          text_node['class'] = "text-danger h4"
        else
          text_node['class'] = "text-primary h4"
        end
      end
      text_node.content = answer[:response].presence || "(unanswered)"
      if answer[:score] == 0 && element['data-answer']
        text_node.content = "#{text_node.content} (#{element['data-answer']})"
      end
      element.add_next_sibling(text_node)
      element.remove
    end
    doc.css('body').children.to_html
  end
end
