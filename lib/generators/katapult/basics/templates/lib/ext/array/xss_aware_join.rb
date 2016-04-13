Array.class_eval do
  def xss_aware_join(delimiter = '')
    ''.html_safe.tap do |str|
      each_with_index do |element, i|
        str << delimiter if i > 0
        str << element
      end
    end
  end
end
