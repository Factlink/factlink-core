module BrowserHelper
  # Makes use of the browser gem:
  # https://github.com/fnando/browser

  def browser_supported?
    return true if browser_preferred?

    browser.safari? or browser.opera? or browser.phantom_js?
  end

  def browser_preferred?
    browser.chrome? or browser.firefox?
  end

  def browser_class_name
    if browser.chrome?
      'chrome'
    elsif browser.firefox?
      'firefox'
    elsif browser.phantom_js?
      'phantom_js unsupported-browser'
    else
      'unsupported-browser'
    end
  end

  def show_supported_browser_warning
    controller_without_warnings = ["tour", "tos"].include? controller_name
    return false if controller_without_warnings

    current_user && browser_supported? && !browser_preferred?
  end
end
