module FormForWithErrors

  def form_for(*args, &block)
    super(*args) do |form|
      html = ''.html_safe
      html << form_errors(form.object)
      html << capture(form, &block)
    end
  end


  private

  def form_errors(object)
    return unless object
    return unless object.respond_to?(:errors)
    return unless object.errors.any?

    safe_messages = object.errors.full_messages.map { |message| h(message) }.join('<br />').html_safe

    styles = <<~CSS
      position: fixed;
      bottom: 0;
      right: 0;
      z-index: 999999;

      border-top: 1px solid #cba;
      border-left: 1px solid #cba;

      padding: 0.5em 1em;
      background-color: #fed;
      opacity: 0.8;

      font-size: 0.8rem;
      color: #821;

      cursor: pointer;
    CSS

    content_tag(:div, safe_messages, style: styles.squish, onclick: 'this.parentNode.removeChild(this)')
  end

end

if Rails.env == 'development'
  ActionView::Helpers::FormHelper.prepend FormForWithErrors
end
