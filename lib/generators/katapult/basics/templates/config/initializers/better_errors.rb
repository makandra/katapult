# Avoid better_errors taking forever to render by ignoring variables larger than
# 10 Kilobytes. Based on https://github.com/charliesome/better_errors/issues/334

if defined?(BetterErrors) && Rails.env.development?
  module BetterErrorsHugeInspectWarning

    def inspect_value(obj)
      inspected = obj.inspect
      if inspected.size > 20_000
        inspected = "Object was too large to inspect (#{inspected.size} bytes)."
      end
      CGI.escapeHTML(inspected)
    rescue NoMethodError
      "<span class='unsupported'>(object doesn't support inspect)</span>"
    rescue Exception
      "<span class='unsupported'>(exception was raised in inspect)</span>"
    end

  end

  BetterErrors.ignored_instance_variables += [:@_request, :@_assigns, :@_controller, :@view_renderer]
  BetterErrors::ErrorPage.prepend(BetterErrorsHugeInspectWarning)
end
