ActionView::Helpers::FormBuilder.class_eval do

  def spec_label(field, text = nil, options = {})
    label_html = label(field)
    element = parse_element(label_html, 'label')
    id = element['for']
    text ||= element.text
    @template.spec_label_tag(id, text, options)
  end

  private

  def parse_element(html, tag)
    doc = Nokogiri::XML(html)
    doc.css(tag).first or raise "Could not find CSS #{tag.inspect} in HTML #{html.inspect}"
  end

end

ActionView::Helpers::FormTagHelper.class_eval do

  def spec_label_tag(id, text = nil, options = {})
    count = SpecLabelCounter.next(controller, text)
    label = count == 1 ? text : "#{text} (#{count})"
    options.merge!(:class => 'hidden') unless Rails.env.test?
    html = label_tag(id, label, options)
    html
  end

end

class SpecLabelCounter
  class << self

    def next(controller, text)
      counter(controller)[text] ||= 0
      counter(controller)[text] += 1
    end

    def counter(controller)
      ivar = :"@_spec_label_counter"
      controller.instance_variable_get(ivar) || controller.instance_variable_set(ivar, {})
    end

  end
end
