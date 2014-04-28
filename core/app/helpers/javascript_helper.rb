module JavascriptHelper
  def javascript_include_base
    debug_mode = Rails.env.development? || Rails.env.test?
    js_variant = "application#{debug_mode ? '_debug' : ''}"
    jquery_include_tag(:google) + javascript_include_tag(js_variant)
  end
end
