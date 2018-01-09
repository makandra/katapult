if Rails.env.development?

  ActionView::Helpers::FormHelper.module_eval do
    def form_for_with_development_errors(*args, &block)
      form_for_without_development_errors(*args) do |form|
        html = ''.html_safe
        html << form_development_errors(form.object)
        html << capture(form, &block)
      end
    end

    alias_method :form_for_without_development_errors, :form_for
    alias_method :form_for, :form_for_with_development_errors

    private

    def form_development_errors(object)
      return unless object
      return unless object.respond_to?(:errors)
      return unless object.errors.any?

      safe_messages = object.errors.full_messages.map { |message| h(message) }.join('<br />').html_safe

      styles = <<~CSS
        position: fixed;
        bottom: 0;
        right: 0;
        z-index: 999999;
        font-size: 0.8rem;
        background-color: #fed;
        border-top: 1px solid #cba;
        border-left: 1px solid #cba;
        color: #821;
        padding: 0.5em 1em;
        cursor: pointer;
        opacity: 0.8;
      CSS

      content_tag(:div, safe_messages, style: styles.squish, onclick: 'this.parentNode.removeChild(this)')
    end
  end

end
