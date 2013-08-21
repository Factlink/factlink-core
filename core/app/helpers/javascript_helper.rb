module JavascriptHelper
  def javascript_include_base
    javascript_include_tag "application"
  end

  def javascript_include_extended
    javascript_include_tag "frontend"
  end
end
