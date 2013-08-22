module JavascriptHelper
  def javascript_include_base
    jquery_include_tag(:google) +
      javascript_include_tag('application')
  end

  def javascript_include_extended
    javascript_include_tag "frontend"
  end
end
