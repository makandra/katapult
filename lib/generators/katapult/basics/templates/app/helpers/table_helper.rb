module TableHelper

  def table(*headers, &block)
    thead = content_tag(:thead) do
      content_tag(:tr) do
        headers.map{ |h| content_tag :th, h }.xss_aware_join
      end
    end
    rest = capture(&block)

    content_tag :table, thead + rest, class: 'table table-hover'
  end

end
