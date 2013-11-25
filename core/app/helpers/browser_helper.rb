module BrowserHelper
  # Makes use of the browser gem:
  # https://github.com/fnando/browser

  def browser_unsupported?
    browser.ie?
  end

  def browser_preferred?
    browser.chrome? or browser.firefox? or browser.phantom_js?
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
    # no unfriendly warnings in the tour
    return false if controller_name == "tour"
    return false unless current_user

    if browser_preferred?
      false # doesn't need warning
    elsif browser_unsupported?
      false # already gets a big warning
    else
      true  # show warning when browser isn't preferred
    end
  end
end
