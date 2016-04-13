if Rails.env == 'development'

  ActionView::Helpers::FormHelper.class_eval do

    def form_for_with_development_errors(*args, &block)
      form_for_without_development_errors(*args) do |form|
        html = ''.html_safe
        if form.object && form.object.respond_to?(:errors) && form.object.errors.any?
          html << content_tag(:div, form.object.errors.full_messages.collect { |m| h m }.join('<br />').html_safe, :class => 'development_errors', :onclick => 'this.parentNode.removeChild(this);')
          html << '<style type="text/css"><!--'.html_safe
          css = <<-EOF
            .development_errors {
              position: fixed;
              bottom: 0;
              right: 0;
              z-index: 999999;
              font-size: 11px;
              line-height: 15px;
              background-color: #fed;
              border-top: 1px solid #cba;
              border-left: 1px solid #cba;
              color: #821;
              padding: 10px;
              cursor: pointer;
              filter:alpha(opacity=80);
              -moz-opacity:0.8;
              -khtml-opacity: 0.8;
              opacity: 0.8;

            }
          EOF
          html << css.html_safe
          html << '</style>'.html_safe
        end
        html << capture(form, &block)
      end
    end

    alias_method_chain :form_for, :development_errors

  end

end
